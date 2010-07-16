Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935870Ab0GPHr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:47:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38592 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713Ab0GPHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=lvLuWxHFg5OpbR7JHIxX8wt33B1dEegblbeDAmCWGxa6IchrB8W78a/AH/WjxS3Jfj
         7FXzwxBtV7Qq5RyqsCuFGt9vFYZDsC53T1O+eo2OGnbsB6ZDSLw89uqxQ+Q5lyZag21j
         i6+ue1T6bmTm5yZtLeFrnmOQUoUchOZwE2x2g=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 01:47:50 -0600
Message-ID: <AANLkTilpacTuIKloyR38XK-Gq7QxkyEEPUbOBjWo5qbq@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger 2.6.30.10 x86_64 07-15-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.30.10-x86_64-07-15-2010.patch

REPOSITORY

http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/

FIXES:
- fix GDB C precedence output for bracketed expressions (fix previous fix)
- enable user space page lookup by default for address < PAGE_OFFSET
- fix pf message in GDB disassembly memory derefencing with user addresses
- backport MDB x86_64 version to Linux Kernel 2.6.28.10
- backport MDB x86_64 version to Linux Kernel 2.6.29.6
- backport MDB x86_64 version to Linux Kernel 2.6.30.10
- backport MDB x86_64 version to Linux Kernel 2.6.31.14
- backport MDB x86_64 version to Linux Kernel 2.6.32.16
- backport MDB x86_64 version to Linux Kernel 2.6.33.6

TODO:
- Integrate GDB opcodes library for all Linux architectures
- add register aliasing for all Linux architectures
- ARM/DSP features for DaVinci
