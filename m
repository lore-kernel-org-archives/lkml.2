Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1AROiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:38:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1AROiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:38:21 -0500
Message-ID: <4D35A5D8.8000204@monstr.eu>
Date: Tue, 18 Jan 2011 15:38:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze build failure fixes for 2.6.38
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have fixed two build failures on the latest code.

Please pull these two patches.

Thanks,
Michal


The following changes since commit 1b59be2a6cdcb5a12e18d8315c07c94a624de48f:
   Linus Torvalds (1):
         Merge branch 'slab/urgent' of 
git://git.kernel.org/.../penberg/slab-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (2):
       microblaze: Fix missing pagemap.h
       microblaze: Fix asm/pgtable.h

  arch/microblaze/include/asm/pgtable.h |    6 ++++--
  arch/microblaze/include/asm/tlb.h     |    1 +
  2 files changed, 5 insertions(+), 2 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
