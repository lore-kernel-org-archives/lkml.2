Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2A3IYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:24:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53135 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2A3IYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:24:06 -0500
Message-ID: <4F2653A2.20506@monstr.eu>
Date: Mon, 30 Jan 2012 09:24:02 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        Ariane Keller <ariane.keller@tik.ee.ethz.ch>
Subject: [GIT PULL] arch/microblaze changes for 3.3 rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this one bug fix for trace code.

Thanks,
Michal

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:
   Linus Torvalds (1):
         Linux 3.3-rc1

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Daniel Borkmann (1):
       microblaze: generic atomic64 support

  arch/microblaze/Kconfig              |    1 +
  arch/microblaze/include/asm/atomic.h |    1 +
  2 files changed, 2 insertions(+), 0 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
