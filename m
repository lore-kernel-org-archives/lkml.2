Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3ABItj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 03:49:39 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52548 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3ABIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 03:49:38 -0500
Message-ID: <50E3F49E.4090005@monstr.eu>
Date: Wed, 02 Jan 2013 09:49:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.8-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these 3 patches.
They fix noMMU kernel and I have also added defconfig updates
which fix issue with one external dependency and enable
all xilinx device drivers for 0-day testing system.

Thanks,
Michal


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:
   Linus Torvalds (1):
         Linux 3.8-rc1

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (3):
       microblaze: Microblaze wants sys_fork for noMMU too
       microblaze: Change section flags for noMMU
       microblaze: Update microblaze defconfigs

  arch/microblaze/configs/mmu_defconfig   | 1572 ++++++++++++++++++++++++++++++-
  arch/microblaze/configs/nommu_defconfig | 1580 ++++++++++++++++++++++++++++++-
  arch/microblaze/include/asm/uaccess.h   |    2 +-
  arch/microblaze/include/asm/unistd.h    |    2 -
  4 files changed, 3102 insertions(+), 54 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
