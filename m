Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1DDPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:49:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1DDPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w1znMoha9fJVvLd4S08GrHjfbyrj2Phw2M9cNg88D0do015PakM9v9OSQIyP6wax8g
         ghxAsRUbNFERp3/b7PCZH9hlPNnaz7bn7KWVxle9SXbyD4lldoJvav1Ao/svr/LV2Nnf
         mjz3uGX/vhdB2Y/Cib6h6gmJkRxMCees1aDMA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikv3kuv7Xqy98giAtQe5xfd3zO0-w@mail.gmail.com>
References: <BANLkTikv3kuv7Xqy98giAtQe5xfd3zO0-w@mail.gmail.com>
Date: Mon, 4 Apr 2011 23:49:44 +0800
Message-ID: <BANLkTikkA2t4ERJt6Pd8iMt0OXXL-TZekQ@mail.gmail.com>
Subject: Re: Patchwork.kernel.org server die ?
From: =?GB2312?B?uN/N8sH6?= <gaowanlong@gmail.com>
To: "Jiejing.Zhang" <kzjeef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like....

2011/4/4, Jiejing.Zhang <kzjeef@gmail.com>:
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
>
