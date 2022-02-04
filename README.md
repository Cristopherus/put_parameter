# put_parameter
Script that can easly put parameter(s) to multiple aws accounts, if only user have proper profiles configured

If sso login is in use - just log first in terminal and then pass all profiles/names that require parameter add/change

$ ./put_parameter.sh 
```Usage: put_parameter.sh [OPTIONS]

Options:
  -e, --envs         environment list (separated by comma, named as aws profiles) i.e. dev,stage,prod
  -p, --parameters   name-value key separated by ; i.e. name1=value1;name2={"key1": "value1", "key2": "value2"}
  -r, --region       aws region (defualt eu-west-1)
  -t, --type         parameter type (defualt SecureString)
```
