Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0INJFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:05:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60797 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0INJFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sPlRrIdfgqc1JHaDuyEWra5BpFbtJ0Td8d4jPgAUAv4ciqVJqvaSc3Ze76DpDj1tvT
         cPevfz1tO6SgYPHmzJWRXB2CF4/Qsr7uDDnc1lJUWkd1l3eYCAdnEexI1n5+D0rZ35qg
         niWuJJH3IVz+8AEvEYr6W0rw4qPgUTQ2CkLx0=
MIME-Version: 1.0
Date: Tue, 14 Sep 2010 13:05:46 +0400
Message-ID: <AANLkTinXKvDzRuPBTcxmANUqNfxbjoTpUNw0Yitu4Okb@mail.gmail.com>
Subject: io.h for powerpc
From: Sergey Naumov <sknaumov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to compile program with inb and outb functions for powerpc
architecture, but I have build error: cannot include <sys/io.h>. I
have found out that there is no sys/io.h for powerpc and started to
search a replacement, e.g. <asm-generic/io.h>, but although there is
asm-generic/io.h in the linux kernel sources, I cant find it in
/usr/include directory of my toolchain. Is it a bug, or there isn't
any io.h for powerpc?

Thanks in advance,

Sergey Naumov.
