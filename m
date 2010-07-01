Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0GAB6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:58:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59697 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0GAB6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=R8Itxft2XQLy9PATnZzQGf/QHMNBYJ5Cw9HWI7/YZ4C1WC7pLACg7tuT3P73N2iE4V
         NEVmA0fbwe8j+frtffKRBipIfH1QU65NxArXMN3ToLo5OHI2Y+QElPZ6TGObLv0jkCoY
         f7IP4uCmKjdbNhW19e2aqfW5iOgk1KusqQN0s=
MIME-Version: 1.0
Date: Wed, 30 Jun 2010 19:58:04 -0600
Message-ID: <AANLkTilcNyApWZxp_E-ZJj1XWT9di9RCYRFIYdxXqpmt@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger x86_64 2.6.34 06-30-2010 
	Release 3
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-x86_64-06-30-2010.patch
http://sourceforge.net/projects/merkeydebugger/


A few fixes for default numeric parsiing with decimal register offsets
to conform to Linux standards and to match displayed register offsets
in both decimal and hex numbers.  Also fixed the default pointer
reference size on expression evaluation to match the machine arch.

FIXES:
- make numeric parsing decimal mode by default unless 0x, x, or A-F
appear in the number, then parse as hex.  This is backwards to how the
NetWare debugger worked, but conforms to Linux standards
- create ARCH_PTR default derefence pointer size based on arch for
default parser disassembly and expression evaluation

TODO
- continue to investigate rex64 sysret instruction issue
- enable segment:address lookups in the disassembler for fs: and gs:,
handle ptr_regs() and OP_E segment:address dereferencing


Jeffrey Vernon Merkey
