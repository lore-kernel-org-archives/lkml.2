Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0DGOFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:05:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37377 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0DGOFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:05:35 -0400
Message-ID: <4BBC9126.10601@monstr.eu>
Date: Wed, 07 Apr 2010 16:05:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.34-rc4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 0fdf86754f70e813845af4abaa805165ce57a0bb:
   Linus Torvalds (1):
         Merge branch 'urgent' of git://git.kernel.org/.../brodo/pcmcia-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

John Linn (1):
       microblaze: io.h: Add io big-endian function

Michal Simek (3):
       microblaze: Fix futex code
       microblaze: Enable memory leak detector
       microblaze: Remove unused variable from ptrace

Steven J. Magnani (1):
       microblaze: Fix ftrace_update_ftrace_func panic

  arch/microblaze/include/asm/futex.h |    2 +-
  arch/microblaze/include/asm/io.h    |    5 +++++
  arch/microblaze/kernel/ftrace.c     |   12 +++---------
  arch/microblaze/kernel/ptrace.c     |    1 -
  lib/Kconfig.debug                   |    2 +-
  5 files changed, 10 insertions(+), 12 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
