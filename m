Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1CETIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:08:06 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56250 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1CETIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TJQLtzmIVfvIkePywlKhn8pOqUdgb2i0XH/vYpx8cL6zyPJ6KYKMnfYtHD6gmvw5wH
         i2JPlnj43Si/gpUnmuJUcmzmADkWsrjIVKav8XFBIXOWovIb0gar9sNseDWPhEiuC7mb
         mQd36ap8hX7dJgtwW8nmMf0VGB5b+FC91IBxo=
MIME-Version: 1.0
Date: Sat, 5 Mar 2011 11:08:04 -0800
Message-ID: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
Subject: X32 psABI status update
From: "H.J. Lu" <hjl.tools@gmail.com>
To: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Many x32 bugs are fixed in kernel, glibc, binutils and GCC:

https://sites.google.com/site/x32abi/

The major remaining issues are glibc/gcc testsuite failures,
kernel core dump and signal handler unwind.


-- 
H.J.
