Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0FGSV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:21:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab0FGSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:21:56 -0400
Message-ID: <4C0D3853.60000@petalogix.com>
Date: Mon, 07 Jun 2010 20:20:03 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are only fixes for Microblaze. There is no any new features. 
(flush_dcache_page patch fix problem on WB system)
Just note: Some new patches broke Microblaze arch that's why I would 
like to add at least these patches to your tree.

Thanks,
Michal


The following changes since commit 386f40c86d6c8d5b717ef20620af1a750d0dacb4:
   Linus Torvalds (1):
         Revert "tty: fix a little bug in scrup, vt.c"

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (7):
       microblaze: Fix __copy_to/from_user_inatomic macros
       microblaze: Sync noMMU and MMU setup_memory
       microblaze: Fix comment for TLB
       microblaze: Implement flush_dcache_page macro
       microblaze: Enable NEED_SG_DMA_LENGTH
       microblaze: Remove unused label
       microblaze: Define ARCH_SLAB_MINALIGN

  arch/microblaze/Kconfig                  |    3 +++
  arch/microblaze/include/asm/cacheflush.h |   13 +++++++++----
  arch/microblaze/include/asm/page.h       |    2 ++
  arch/microblaze/include/asm/uaccess.h    |    4 ++--
  arch/microblaze/kernel/misc.S            |    2 +-
  arch/microblaze/mm/fault.c               |    1 -
  arch/microblaze/mm/init.c                |    7 +------
  7 files changed, 18 insertions(+), 14 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
