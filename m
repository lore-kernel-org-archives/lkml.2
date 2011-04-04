Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1DDP5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:57:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40202 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab1DDP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=sOQ2v8R+8yIm+7Rn38XFlN5EXj7JoRWAgFbrr9Q/d5nAocUt13K8581YtM7GLj2w4o
         GAKFGoOLQJ//bHvIQSZh3QPX/yItUqqU4UhtGM4aNQzN7KBlfmJTfhY5keGtx0lSl1rj
         yw4kaqrRqEwtkyXr8/J8eIs/AwngZ327a20J0=
Subject: Re: Patchwork.kernel.org server die ?
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: "Jiejing.Zhang" <kzjeef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 04 Apr 2011 08:57:26 -0700
In-Reply-To: <BANLkTikv3kuv7Xqy98giAtQe5xfd3zO0-w@mail.gmail.com>
References: <BANLkTikv3kuv7Xqy98giAtQe5xfd3zO0-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1301932649.32111.0.camel@Linux-2>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 23:36 +0800, Jiejing.Zhang wrote:
> Hi Guys,
> 
> Can you access https://patchwork.kernel.org/ ?
> 
> seems the server is die ?
> 
> I got this error for every time access https://patchwork.kernel.org/
> 
> OperationalError at /project/linux-input/list/
> 
> (2003, "Can't connect to MySQL server on 'mysql-ro1.sql.kernel.bak' (113)")
> 
> Request Method: GET
> Request URL: https://patchwork.kernel.org/project/linux-input/list/
> Django Version: 1.2.5
> Exception Type: OperationalError
> Exception Value:
> 
> (2003, "Can't connect to MySQL server on 'mysql-ro1.sql.kernel.bak' (113)")
> 
> Exception Location:
> /usr/lib64/python2.7/site-packages/MySQLdb/connections.py in __init__,
> line 187
> Python Executable: /usr/bin/python
> Python Version: 2.7.0
> Python Path: ['/var/www/patchwork/apps', '/var/www/patchwork',
> '/var/www/patchwork/lib/python', '/usr/lib64/python27.zip',
> '/usr/lib64/python2.7', '/usr/lib64/python2.7/plat-linux2',
> '/usr/lib64/python2.7/lib-tk', '/usr/lib64/python2.7/lib-old',
> '/usr/lib64/python2.7/lib-dynload',
> '/usr/lib64/python2.7/site-packages',
> '/usr/lib64/python2.7/site-packages/Numeric',
> '/usr/lib64/python2.7/site-packages/PIL',
> '/usr/lib64/python2.7/site-packages/gtk-2.0',
> '/usr/lib/python2.7/site-packages',
> '/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info']
> Server time: Mon, 4 Apr 2011 15:30:41 +0000
> 
> Best regards,
> Zhang Jiejing
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


yeah I get this:
http://www.flickr.com/photos/44066293@N08/5588772127/

must be maintaining it or something..

Justin P. Mattock

