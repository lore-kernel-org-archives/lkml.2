Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab0HFDuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:50:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0HFDuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=t3ZWNrJnlXZdjxaccdyw9xYjo10kvutUuBuDo4qFvFKVswRLjeJxBYv/d1nJ/CDARb
         bm37ZIHNR7Rhf7E2JU573c+Pmv2JlPVrhwXrrJM6nRtqD3wqgvpVsZAnncArRr8UB7CI
         dcxTpX4JunAUw0UW0CluuaOuOuVPq3BOOYj4Q=
MIME-Version: 1.0
Date: Thu, 5 Aug 2010 21:50:17 -0600
Message-ID: <AANLkTikV1-jK56yg35K5vt0JX2GoT6Uor+9N_9cfexcz@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Linux Kernel Debugger 2.6.35 x86_64 
	08-05-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT
http://merkeydebugger.googlecode.com/files/mdb-2.6.35-x86_64-08-05-2010.patch

REPOSITORY

http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/

FIXES:
- move debug/mdb directories and build to kernel/debug/mdb to
  where kdb and kgdb are located with the kernel debuggers
- integrate into the kernel debug Makefile in kernel/debug/
- fix fpu_alloc function in i386.h set to GFP_DMA instead of
  GFP_KERNEL
- fix sched.c exports
- fix modules_use references in module.c
- regression test UP and CONFIG_SMP x86_64 and ia32 version
  2.6.35

TODO:
- Integrate GDB opcodes library for all Linux architectures
