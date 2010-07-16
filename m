Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935857Ab0GPHru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:47:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51974 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713Ab0GPHrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=CMP7bSD/7qV03K7kbxueDkS05kwv8TGXq/+6Xe/WOv10LI+dD3Dzg8B5jARzv2mDIq
         dePSNazYRyF4TgwXDqKqa92qtkz0OcvXW0m3GH34mHtOxxH/PltsywvkOL9yuNCvjNji
         4KCvbaBWcITtoeS5ic5+UiDkhWMBVZKaaHT5s=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 01:47:44 -0600
Message-ID: <AANLkTiniLY5K6gueyVBQFCCMCCcB4AGqigxigtUN6apt@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger 2.6.29.6 x86_64 07-15-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.29.6-x86_64-07-15-2010.patch


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
