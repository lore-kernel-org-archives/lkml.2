Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0FIOeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 10:34:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab0FIOeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 10:34:06 -0400
Message-ID: <4C0FA5E9.1050001@monstr.eu>
Date: Wed, 09 Jun 2010 16:32:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL v3] arch/microblaze fixes for 2.6.35-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following regression fixes.

Thanks,
Michal


The following changes since commit 84f7586edab93052bbe7eb72e1e9bce5f7b6ae45:
   Linus Torvalds (1):
         Merge branch 'for-linus' of 
git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

FUJITA Tomonori (1):
       microblaze: Fix sg_dma_len() regression

Michal Simek (1):
       microblaze: Define ARCH_SLAB_MINALIGN to fix slab crash

  arch/microblaze/include/asm/page.h |    2 ++
  arch/microblaze/kernel/dma.c       |    1 -
  2 files changed, 2 insertions(+), 1 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
