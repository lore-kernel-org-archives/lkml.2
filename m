Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1DDPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:41:05 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:34311 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1DDPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=kupKMIHxH5EZI7V1ljV1CVs+4Qu01aq/k9fPULIp7b1BbjwltgAMpcJRSvItqdQ0cU
         XnUD9VRtlfkqOTu54JnmO6gcEnYpn/OSLwM5/k1DRhPhi9YUhgm629Wo4gvJwIzdBHqf
         Ujs9Rb3jmg6CWVnKMd93SVZCNlM0fTZLMWPDQ=
MIME-Version: 1.0
From: "Jiejing.Zhang " <kzjeef@gmail.com>
Date: Mon, 4 Apr 2011 23:36:18 +0800
Message-ID: <BANLkTikv3kuv7Xqy98giAtQe5xfd3zO0-w@mail.gmail.com>
Subject: Patchwork.kernel.org server die ?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Can you access https://patchwork.kernel.org/ ?

seems the server is die ?

I got this error for every time access https://patchwork.kernel.org/

OperationalError at /project/linux-input/list/

(2003, "Can't connect to MySQL server on 'mysql-ro1.sql.kernel.bak' (113)")

Request Method: GET
Request URL: https://patchwork.kernel.org/project/linux-input/list/
Django Version: 1.2.5
Exception Type: OperationalError
Exception Value:

(2003, "Can't connect to MySQL server on 'mysql-ro1.sql.kernel.bak' (113)")

Exception Location:
/usr/lib64/python2.7/site-packages/MySQLdb/connections.py in __init__,
line 187
Python Executable: /usr/bin/python
Python Version: 2.7.0
Python Path: ['/var/www/patchwork/apps', '/var/www/patchwork',
'/var/www/patchwork/lib/python', '/usr/lib64/python27.zip',
'/usr/lib64/python2.7', '/usr/lib64/python2.7/plat-linux2',
'/usr/lib64/python2.7/lib-tk', '/usr/lib64/python2.7/lib-old',
'/usr/lib64/python2.7/lib-dynload',
'/usr/lib64/python2.7/site-packages',
'/usr/lib64/python2.7/site-packages/Numeric',
'/usr/lib64/python2.7/site-packages/PIL',
'/usr/lib64/python2.7/site-packages/gtk-2.0',
'/usr/lib/python2.7/site-packages',
'/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info']
Server time: Mon, 4 Apr 2011 15:30:41 +0000

Best regards,
Zhang Jiejing
