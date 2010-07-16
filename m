Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935912Ab0GPHsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:48:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51974 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935863Ab0GPHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dpvvAIZi51IrIJSnRjdf2ToBepjBvHZ17NxwOVHt3q37qgcHF0nQIfc6RMmE4aNIKi
         nOdl444EvLK1vK4zQinGWDOR4U3rYGLnatLN29xe4MBXoDe2YpHxQu7JYS+R496mTTBO
         AO5BIHfNM4YXmkHitnaOLS24EQ/zC+/wyKMPU=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 01:47:54 -0600
Message-ID: <AANLkTilfVezZEDl-DaWnqGafeop946J11VMcEk-geD-P@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger 2.6.31.14 x86_64 07-15-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.31.14-x86_64-07-15-2010.patch

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
