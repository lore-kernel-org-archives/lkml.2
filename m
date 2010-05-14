Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0ENFzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:55:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0ENFzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:55:46 -0400
Message-ID: <4BECE5B2.3090108@monstr.eu>
Date: Fri, 14 May 2010 07:54:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.34-rc8 v2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

as I mentioned in the previous email. Here is the new pull request 
which contains one more bug fix.

Thanks,
Michal


The following changes since commit be835674b55324c1abe973b15343c3663910c620:
   Linus Torvalds (1):
         Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (4):
       microblaze: Remove compilation warnings in cache macro
       microblaze: Remove powerpc code from Microblaze port
       microblaze: export assembly functions used by modules
       microblaze: Fix module loading on system with WB cache

Steven J. Magnani (3):
       microblaze: re-enable interrupts before calling schedule
       microblaze: fix get_user/put_user side-effects
       microblaze: export assembly functions used by modules

  arch/microblaze/include/asm/uaccess.h     |   87 
+++++++++++++++++++++++------
  arch/microblaze/kernel/cpu/cache.c        |    3 +-
  arch/microblaze/kernel/entry-nommu.S      |    2 +
  arch/microblaze/kernel/microblaze_ksyms.c |   11 ++++
  arch/microblaze/kernel/module.c           |    2 +
  arch/microblaze/mm/init.c                 |    1 +
  arch/microblaze/mm/pgtable.c              |    1 +
  arch/microblaze/pci/pci-common.c          |    2 +-
  8 files changed, 89 insertions(+), 20 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
