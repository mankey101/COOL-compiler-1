package cool;

interface Visitor {

    // Non-Expression visitors

    // Visits a program (which contains the classes)
    public void visit(AST.program prog);

    // Visits a single class
    public void visit(AST.class_ cl);

    // Visits the attributes of the class
    public void visit(AST.attr at);

    // Visits the method of the class
    public void visit(AST.method mthd);

    // Visits the formals of the method
    public void visit(AST.formal fm);

    // Expression visitors
    // All the expressions returns the resultant register 
    // of the evaluated expression. 
    // For primitie types its directly the value (i32, i8 or i8*)
    // For other objects, its a pointer to the object
    
    // Used for no_expression
    public String visit(AST.no_expr expr);

    // Visits 'ID <- expr' expression
    public String visit(AST.assign expr);

    // Visits 'expr@TYPE.ID([expr [[, expr]]∗])' expression
    public String visit(AST.static_dispatch expr);

    // Visits 'expr.ID([expr [[, expr]]∗])' expression
    public String visit(AST.dispatch expr);

    // Visits 'if expr then expr else expr fi' expression
    public String visit(AST.cond expr);

    // Visits 'while expr loop expr pool' expression
    public String visit(AST.loop expr);

    // Visits '{ [expr;]+ }' expression
    public String visit(AST.block expr);

    // Visits 'let ID : TYPE [<-expr] in expr' expression
    // NOTE: muliple ID declaration is converted to nested let by parser
    public String visit(AST.let expr);

    // Visits 'case expr of [ID : TYPE => expr;]+ esac' expression
    public String visit(AST.typcase expr);

    // Visits 'ID : TYPE => expr;'
    // This is not an expression, but used inside case
    public String visit(AST.branch br);

    // Visits 'new TYPE' expression
    public String visit(AST.new_ expr);

    // Visits 'isString expr' expression
    public String visit(AST.isvoid expr);

    // Visits 'expr + expr' expression
    public String visit(AST.plus expr);

    // Visits 'expr - expr' expression
    public String visit(AST.sub expr);
    
    // Visits 'expr * expr' expression
    public String visit(AST.mul expr);
    
    // Visits 'expr / expr' expression
    public String visit(AST.divide expr);
    
    // Visits 'not expr' expression
    public String visit(AST.comp expr);
    
    // Visits 'expr < expr' expression
    public String visit(AST.lt expr);
    
    // Visits 'expr <= expr' expression
    public String visit(AST.leq expr);
    
    // Visits 'expr = expr' expression
    public String visit(AST.eq expr);
    
    // Visits '~expr' expression
    public String visit(AST.neg expr);
    
    // Visits 'ID' expression
    public String visit(AST.object expr);
    
    // Visits integer expression
    public String visit(AST.int_const expr);
    
    // Visits string expression
    public String visit(AST.string_const expr);
    
    // Visits bool expression
    public String visit(AST.bool_const expr);

}