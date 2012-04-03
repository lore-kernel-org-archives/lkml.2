Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2DCMOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:14:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64697 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2DCMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:14:29 -0400
Message-ID: <4F7AE99E.5000804@monstr.eu>
Date: Tue, 03 Apr 2012 14:14:22 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120314 Thunderbird/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.4-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fixes.

Thanks,
Michal


The following changes since commit f52b69f86e27903d6896ed5fa7cd280fec8de532:

   Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh (2012-03-30 00:09:17 -0700)

are available in the git repository at:


   git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to 0dd90aa9d6222e12201f05c0058e8741b7f66474:

   microblaze: Fix ret_from_fork declaration (2012-04-02 13:00:26 +0200)

----------------------------------------------------------------
Michal Simek (7):
       microblaze: Fix __futex_atomic_op macro register usage
       microblaze: Fix tlb_skip variable on noMMU system
       microblaze: Fix stack usage in PAGE_SIZE copy_tofrom_user
       Merge git://git.kernel.org/.../torvalds/linux-2.6 into next
       microblaze: Add missing headers caused by disintegration asm/system.h
       microblaze: Do not use tlb_skip in early_printk
       microblaze: Fix ret_from_fork declaration

  arch/microblaze/include/asm/cmpxchg.h   |    2 ++
  arch/microblaze/include/asm/futex.h     |    2 +-
  arch/microblaze/include/asm/processor.h |    4 ++--
  arch/microblaze/kernel/early_printk.c   |    2 ++
  arch/microblaze/kernel/setup.c          |    2 ++
  arch/microblaze/kernel/unwind.c         |    1 +
  arch/microblaze/lib/uaccess_old.S       |   98 +++++++++++++++++++++++++++++++++++++++++++++++----------------------------
  7 files changed, 72 insertions(+), 39 deletions(-)




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
