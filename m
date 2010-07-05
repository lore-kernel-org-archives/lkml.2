Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0GECL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 22:11:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0GECL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 22:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lrsW91z9VYuhQY5TS9AR2vSBOHn/R7+qqkLv6atA7eJhNi5agRArcuFqzwZb/XUxc9
         JUb3My7rbRa4PWQ9RpiVOevlwLGKsbyFTP3+WJ7ajdefOpp2/gj1k1VpAzbWRjaaXDHX
         YKTI/qJXivKFiPQmkt/TbQH3yVzlBI6cgjWME=
MIME-Version: 1.0
Date: Sun, 4 Jul 2010 20:11:56 -0600
Message-ID: <AANLkTin1UfGQYyzktkX-DZQWMT_7Do3dT46iCLKzjaWS@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger x86_64 2.6.34 07-04-2010 
	Release 6
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-x86_64-07-04-2010.patch

REPOSITORY

http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/

FIXES:
- fixed rex64 sysret/sysexit lockup on x86_64 and ia32
- removed MDB conditionals from arch/x86/kernel/traps.c
- fixed debug exception problem with sysret and sysexit instructions
- added .TM toggle to allow stepping in user space address ranges
- added TOGGLE command to display all toggle settings
- fixed needs_proceed flag detection in mdb-ia-support
- fixed trace problem when stepping over iret and iretd instructions

TODO
- look at builds for each release candidate as well as major releases
- ARM disassembler integration for 26 bit and 32 bit modes
- ARM command and logic integration


Jeffrey Vernon Merkey
