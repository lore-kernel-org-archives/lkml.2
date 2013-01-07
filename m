Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3AGO7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:59:24 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62381 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3AGO7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:59:23 -0500
Message-ID: <50EAE126.4020407@monstr.eu>
Date: Mon, 07 Jan 2013 15:52:22 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 3.8-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is fixed pull request (origin one was sent some days ago).
I have fixed defconfigs as you suggested. In that meantime I have
also found 3 other things which needs to be fixed which are also
included (Highmem fixup and pci warnings reported by 0-day testing system).

Thanks,
Michal



The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
   Linus Torvalds (1):
         Linux 3.8-rc2

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (6):
       microblaze: Microblaze wants sys_fork for noMMU too
       microblaze: Change section flags for noMMU
       microblaze: Kill __kmap_atomic()
       microblaze: Add finit_module syscall
       microblaze: Fix pci compilation and sparse warnings
       microblaze: Update microblaze defconfigs

  arch/microblaze/configs/mmu_defconfig     |   52 ++++++++++++++------
  arch/microblaze/configs/nommu_defconfig   |   73 +++++++++++++++++-----------
  arch/microblaze/include/asm/highmem.h     |    2 +-
  arch/microblaze/include/asm/uaccess.h     |    2 +-
  arch/microblaze/include/asm/unistd.h      |    2 -
  arch/microblaze/include/uapi/asm/unistd.h |    3 +-
  arch/microblaze/kernel/syscall_table.S    |    1 +
  arch/microblaze/pci/pci-common.c          |   11 ++--
  8 files changed, 90 insertions(+), 56 deletions(-)



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
