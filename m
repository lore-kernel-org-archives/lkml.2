Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab0GIQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:53:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36572 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab0GIQxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=QPUHSNLMuv/XgmpZVRT/sIqbaJ7/N01PZiZ7sRcYB6wtiCRx6uZxjKtO/u0EL6ED2Y
         vi9DDWODF40NJ7BATyy8kQPp4ZKGvP0OtVcWxyFSuLTlyoojAMXJHeGOjk4Ydr3krJeE
         qYI9C7B5JMaySikqmysuS70mpEMFg2Zl79jE4=
MIME-Version: 1.0
Date: Fri, 9 Jul 2010 10:53:19 -0600
Message-ID: <AANLkTimLDcnf8EqNzP6K4wCLv6AkLUqxczo05BT7I4Hy@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger 2.6.34.1 x86_64 07-08-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.34.1-x86_64-07-08-2010.patch

REPOSITORY

http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/

FIXES
- fix precedence output in GDB disassembler with scalar expressions
i.e. (rax + (rbx * 8)) to conform to C Language precedence rules
- fix fpu_init code in arch/x86/kernel/i387.c to use GFP_DMA instead
of  GFP_KERNEL since GFP_KERNEL should not be called from an exception
context
- regression test 2.6.34.1 on ia32/x86_64 4 way Opteron and ia32 UP

TODO
- add GDB disssembler opcodes library for all linux arch (port in process)
- add GDB registers and memory commands, abstract register naming in the code
- restructure ARM command reference for DaVinci support
- add DSP support for debugging ARM/DSP domains
