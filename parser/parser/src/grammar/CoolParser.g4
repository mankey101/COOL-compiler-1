parser grammar CoolParser;

options {
    tokenVocab = CoolLexer;
}

@header{
    import java.util.List;
}

@members{
    String filename;
    public void setFilename(String f){
        filename = f;
    }

/*
    DO NOT EDIT THE FILE ABOVE THIS LINE
    Add member functions, variables below.
*/

}

/*
    Add appropriate actions to grammar rules for building AST below.
*/

// Root of all grammars. Entire program converges to this.
program returns [AST.program value] : 
    cl=class_list EOF {
        $value = new AST.program($cl.value, $cl.value.get(0).lineNo);    
    };                    

// List of all the classes
class_list returns [List<AST.class_> value] 
    @init {
        $value = new ArrayList<>();
    }
    : (cl = class_ SEMICOLON { $value.add($cl.value); })+;

// A single class
class_ returns [AST.class_ value] 
    : 
    // class without inheritance
    cl=CLASS t=TYPEID LBRACE fl=feature_list RBRACE {
        // By default "Object" class is parent of all class
        $value = new AST.class_($t.getText(), filename, "Object", 
                $fl.value, $cl.getLine());
    }
    |
    // class with inheritance
    cl=CLASS t=TYPEID (INHERITS pcl=TYPEID) LBRACE fl=feature_list RBRACE {
        $value = new AST.class_($t.getText(), filename, $pcl.getText(),
                $fl.value, $cl.getLine());
    };

// list of features
feature_list returns [List<AST.feature> value] 
    @init {
        $value = new ArrayList<>();
    }
    : (f = feature SEMICOLON { $value.add($f.value); })*;

// a function or variable declaration (with or without assignment)
feature returns [AST.feature value]: 
    // method without formal_list
    m=OBJECTID LPAREN RPAREN COLON t=TYPEID LBRACE b=expr RBRACE {
        $value = new AST.method($m.getText(), new ArrayList<AST.formal>(), 
            $t.getText(), $b.value, $m.getLine());
    }
    |
    // method with formal_list
    m=OBJECTID LPAREN f=formal_list RPAREN COLON t=TYPEID LBRACE b=expr RBRACE {
        $value = new AST.method($m.getText(), $f.value, $t.getText(), 
            $b.value, $m.getLine());
    }
    // variable declaration without assignment
    | v=OBJECTID COLON t=TYPEID {
        $value = new AST.attr($v.getText(), $t.getText(), new AST.no_expr($v.getLine()),
            $v.getLine());
    }
    |
    // variable declaration with assignment
    | v=OBJECTID COLON t=TYPEID ( ASSIGN e=expr ) {
        $value = new AST.attr($v.getText(), $t.getText(), $e.value, $v.getLine());
    };

// list of formals
formal_list returns [List<AST.formal> value]
    @init {
        $value = new ArrayList<>();
    }
    : f=formal { $value.add($f.value); } 
    (COMMA f2=formal { $value.add($f2.value); })*;

// variable declarations
formal returns [AST.formal value] : 
    o=OBJECTID COLON t=TYPEID {
        $value = new AST.formal($o.getText(), $t.getText(), $o.getLine());
    };

// list branches of type case
branch_list returns [List<AST.branch> value]
    @init {
        $value = new ArrayList<>();
    }
    : (b=branch { $value.add($b.value); })+;

// a branch in type case
branch returns [AST.branch value] :
    o=OBJECTID COLON t=TYPEID DARROW e=expr SEMICOLON {
        $value = new AST.branch($o.getText(), $t.getText(), $e.value, $o.getLine());
    };

// list of expressions ending with semicolon
block_expression_list returns [List<AST.expression> value] 
    @init {
        $value = new ArrayList<>();
    }
    : (e=expr SEMICOLON { $value.add($e.value); } )+;

// list of expressions separated by comma
expr_list returns [List<AST.expression> value]
    @init {
        $value = new ArrayList<>();
    }
    : 
    (
        e1=expr { $value.add($e1.value); }
                (COMMA e2=expr { $value.add($e2.value); })*
    )?;

/* LET assignments */
// list of assignments in a let statement
let_assignment_list returns [List<AST.attr> value]
    @init {
        $value = new ArrayList<>();
    }
    : 
    f=first_let_assignment { $value.add($f.value); }
    ( la=next_let_assignment { $value.add($la.value); } )*;

// first varaible declaration in let statement (which doesnt start with comma)
first_let_assignment returns [AST.attr value]
    :
    o=OBJECTID COLON t=TYPEID {
        $value = new AST.attr($o.getText(), $t.getText(), new AST.no_expr($o.getLine()), $o.getLine());
    }
    |
    o=OBJECTID COLON t=TYPEID ASSIGN e=expr {
        $value = new AST.attr($o.getText(), $t.getText(), $e.value, $o.getLine());
    };

// variable declarations in let statement which starts with comma (2nd and further declarations)
next_let_assignment returns [AST.attr value]
    :
    c=COMMA o=OBJECTID COLON t=TYPEID {
        $value = new AST.attr($o.getText(), $t.getText(), new AST.no_expr($c.getLine()), $c.getLine());
    }
    |
    c=COMMA o=OBJECTID COLON t=TYPEID ASSIGN e=expr{
        $value = new AST.attr($o.getText(), $t.getText(), $e.value, $c.getLine());
    };

/* All kinds of expressions */
expr returns [AST.expression value]: 
        
        // dispatch (a function call of an object)
        e1=expr DOT o=OBJECTID LPAREN el=expr_list RPAREN {
            $value = new AST.dispatch($e1.value, $o.getText(), $el.value, $e1.value.lineNo);
        }
        | 
        // static dispatch
        e1=expr ATSYM t=TYPEID DOT o=OBJECTID LPAREN el=expr_list RPAREN {
            $value = new AST.static_dispatch($e1.value, $t.getText(), $o.getText(), 
                $el.value, $e1.value.lineNo);
        }
        | 
        // function call of self
        o=OBJECTID LPAREN el=expr_list RPAREN {
            $value = new AST.dispatch(new AST.object("self", $o.getLine()), $o.getText(),
                $el.value, $o.getLine());
        }
        | 
        // if e2 then e2 else e3 fi
        i=IF e1=expr THEN e2=expr ELSE e3=expr FI {
            $value = new AST.cond($e1.value, $e2.value, $e3.value, $i.getLine());
        }
        | 
        // while e1 loop e2 pool
        wh=WHILE e1=expr LOOP e2=expr POOL {
            $value = new AST.loop($e1.value, $e2.value, $wh.getLine());
        }
        | 
        // block expression
        // { e1; e2; e3; ... }
        lb=LBRACE bel=block_expression_list RBRACE {
            $value = new AST.block($bel.value, $lb.getLine());
        }
        | 
        // let statement with declarations and expression
        l=LET lal=let_assignment_list IN e=expr {
            AST.expression current_expr = $e.value;
            int size = $lal.value.size();
            for(int i=size-1; i>=0; i--) {
                AST.attr let_attr = $lal.value.get(i);
                current_expr = new AST.let(let_attr.name, let_attr.typeid, let_attr.value, current_expr, $l.getLine());
            }
            $value = current_expr;
        }
        | 
        // case e of bl esac
        c=CASE e=expr OF bl=branch_list ESAC {
            $value = new AST.typcase($e.value, $bl.value, $c.getLine());
        }
        | 
        // new t
        nw=NEW t=TYPEID {
            $value = new AST.new_($t.getText(), $nw.getLine());
        }
        | 
        // ~ e
        tl=TILDE e=expr {
            $value = new AST.comp($e.value, $tl.getLine());
        }
        | 
        // isvoid expression
        iv=ISVOID e1=expr {
            $value = new AST.isvoid($e1.value, $iv.getLine());
        }
        | 
        // multiplication
        e1=expr STAR e2=expr {
            $value = new AST.mul($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // division
        e1=expr SLASH e2=expr {
            $value = new AST.divide($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // addition
        e1=expr PLUS e2=expr {
            $value = new AST.plus($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // e1 - e2
        e1=expr MINUS e2=expr {
            $value = new AST.sub($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // e1 < e2
        e1=expr LT e2=expr {
            $value = new AST.lt($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // e1 <= e2
        e1=expr LE e2=expr {
            $value = new AST.leq($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // e1 = e2
        e1=expr EQUALS e2=expr {
            $value = new AST.eq($e1.value, $e2.value, $e1.value.lineNo);
        }
        | 
        // not expr
        nt=NOT e1=expr {
            $value = new AST.neg($e1.value, $nt.getLine());
        }
        | 
        // o <- e
        <assoc=right>o=OBJECTID ASSIGN e=expr {
            $value = new AST.assign($o.getText(), $e.value, $o.getLine());
        }
        | 
        // (e)
        LPAREN e=expr RPAREN {
            $value = $e.value;
        }
        | 
        // object
        o=OBJECTID {
            $value = new AST.object($o.getText(), $o.getLine());
        }
        | 
        // integer constant
        i=INT_CONST {
            $value = new AST.int_const(Integer.parseInt($i.getText()), $i.getLine());
        }
        | 
        // string constant
        s=STR_CONST {
            $value = new AST.string_const($s.getText(), $s.getLine());
        }
        | 
        // bool constant
        b=BOOL_CONST {helloimlm .m;/m;
            $value = new AST.bool_const("true".equalsIgnoreCase($b.getText()), $b.getLine());
        }
        ;
