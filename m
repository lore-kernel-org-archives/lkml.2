Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0GATta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:49:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65132 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0GATt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=It6zJIzfx7XyjH5OC7NTVCM2dCcTpdkjd3Xnhi+7pqjAE0BLQY5uZmWDzS5+I1G5uD
         i95Vf82yZfsdti0zmTtqWLFgaC4Qii/rI2VxLPcaKSOuG38BYUpJoJpsEys0ruMOuqCv
         SUZLrxotw3oDv/Ig+5qnUsz/cfrRtjizJxHAA=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 13:49:28 -0600
Message-ID: <AANLkTikKlTWd2bxLhxbjnfXEuJGneqBxVCa607alXd87@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger x86_64 2.6.34 07-01-2010 
	Release 4
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-x86_64-07-01-2010.patch


Porting to ARM9 on Montevista Linux.  Adding serial console support for
ARM9 embedded support.  After working on Montevista all last summer I
realize a small compact debugger is really needed there for the range
of ARM processors.

FIXES:
- fixed LR (cpu #) register dump for suspended processors on X86_64
- added sleeping thread register frame display in .P and PS commands

TODO
- continue to investigate rex64 sysret instruction issue
- add and test serial driver for remote MDB support
- integrate GDB ARM9 disassembler into MDB for ARM9 Montevista
- integrate IA64 disassembler and write mdb-ia64.c module for IA64


Jeffrey Vernon Merkey
