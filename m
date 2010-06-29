Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab0F2EQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:16:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62518 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0F2EQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iCXBGlkL2Y1J/G4B/WwgpIdl3uAHhGQV2HIjMNhpfyEVavmrfyinY/hwTdJopOxoqj
         olCFD6dQcsejvzziy0wlyC0BqxNGGoOr4Kpm4Ju9EHwyedso6IIR7vRMxyh7SsLGTgWT
         2f4obnNdoRu0p0F3z9j59x+uaStuMFt8D9zGw=
MIME-Version: 1.0
Date: Mon, 28 Jun 2010 22:16:23 -0600
Message-ID: <AANLkTinu1dXxNlCDA3NF5OJbnWkgCGXGReAVcM-JfUwu@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger x86_64 2.6.34 06-28-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-x86_64-06-28-2010.patch

This is the first full x86_64 version of MDB.  This
implementation of MDB also uses the x86_64 and IA32 versions of the
GDB disassmbler instead of the older IA32 disassembler from previous
version of MDB.  bfd has been integrated into MDB which will support
easy porting of MDB to other processor types.  I used the kdb
disassembler GDB source base and added all the MDB features
and layout (intel style).  This version also supports 8086
disassembly and IA32.  There is a short list of items left on the
list and I will update these as I have more time to work on MDB.


FIXES:

- complete X86_64 register functions
- port GDB(kdb) X86_64/IA32/8086 disassembler to MDB
- remove older IA32 disassembler
- add GDT/IDT support for x86_64
- add X86_64 registers to numeric parse evaluator
- fix stack and SP setup for x86_64
- fix register display and enable 64 bit registers
- add memory derefencing to the GDB disassembler
- add jump direction labeling to the GDB disassembler
- add kallsyms global variable display and dereferencing
- add segment register deferencing for segment:offset pairs
- integrate mdb-logic numeric parser into the GDB debugger
- add ansidecl and bfd included and architecture into MDB
- add ID command with both att and intel disassembly styles
- fix all hex/decimal(0x) formats to conform with Linux standards
- change dereferencing for register indirection to use both decimal and hex
offsets
- conditionalize the GDB disassembler and modularlize the MDB enhancements
- export in_interrupt_stack and get_irq_stack_ptr for 64 bit stack tracing
- add quad word memory dump capability and quad word stack dump
- add register:address parsing to mdb-logic and segment token memory
  referencing
- fix GDT/IDT pointer stack problems

TO DO
- fix "rex64 sysret" instruction keyboard issue (anyone have any ideas)
- add all fs: gs: and es: deferencing assembler stub cases in disassembly
- add vma, follow_page (nommu.c) functions when nommu.c is not linked
- add getarea and putarea functions which map user addresses with follow_page


Jeff Merkey
