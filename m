Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1BJHuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:50:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43158 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1BJHub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:50:31 -0500
Message-ID: <4D5398C3.3060501@monstr.eu>
Date: Thu, 10 Feb 2011 08:50:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze bug fixes for 2.6.38-rc5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following bug fixes for microblaze.

Thanks,
Michal

The following changes since commit 8dbdea8444d303a772bceb1ba963f0e3273bfc5e:
   Linus Torvalds (1):
         Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (4):
       microblaze: Fix IRQ flag handling for MSR=0
       microblaze: Fix asm compilation warning
       microblaze: Fix pte_update function
       microblaze: Fix msr instruction detection

  arch/microblaze/include/asm/irqflags.h |    2 +-
  arch/microblaze/include/asm/pgtable.h  |   27 +++++++++++++--------------
  arch/microblaze/kernel/cpu/pvr.c       |    4 ++--
  arch/microblaze/kernel/head.S          |   15 +++++++--------
  arch/microblaze/kernel/setup.c         |    4 ++--
  5 files changed, 25 insertions(+), 27 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
