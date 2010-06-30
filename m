Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0F3GBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:01:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59559 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0F3GBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=p8kCO4inomvwOJKzEod3M7qeW3KSghXVgD0Sl090Jzf98Ks7VR62rAJFadbXtdN/ap
         cWLXH26M/nK7bnJnPsuvYLiWb6zonvPCculhRsDBx/wAnTIF/gu22JU7/M4TJdL+Kghq
         /HnFEXsXLzc55mmW2asPAmwNfSNw7CPxPRWX0=
MIME-Version: 1.0
Date: Wed, 30 Jun 2010 00:01:44 -0600
Message-ID: <AANLkTinN9JWHrORsypcgcv1rzkREJrhT0i3kK-6Kh9i4@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Kernel Debugger x86_64 2.6.34 06-29-2010 
	Release 2
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://merkeydebugger.googlecode.com/files/mdb-2.6.34-x86_64-06-29-2010.patch


The remaining issues are not critical path and MDB is stable on x86_64
and ia32 with this release.  Will update the TODO items as I have
time.  email me if there are additional features or issues found.

FIXES:
- fixed DS and W commands to output qwords in stack argument dump
- add find_extend_vma and follow_page to exported symbols
- add ds: and es: segment lookups in disassembler
- enable .TM flag to toggle memory read between physical and user
space read/write for addresses < PAGE_OFFSET

TODO
- continue to investigate rex64 sysret instruction issue
- add page mapping mode flag to dump commands to specify between
logical, physical, and userspace page maps during data dumps i.e. d
10000u (user), d 10000p (phys), d 10000 or d 10000m (mapped)
- enable segment:address lookups in the disassembler for fs: and gs:,
handle ptr_regs() and OP_E segment:address dereferencing


Jeffrey Vernon Merkey
