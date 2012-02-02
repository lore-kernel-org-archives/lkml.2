Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2BBKys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:54:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61966 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2BBKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:54:47 -0500
Message-ID: <4F2A6B74.4030500@monstr.eu>
Date: Thu, 02 Feb 2012 11:54:44 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.3 rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I had to revert one patch because another patch turned on generic Kconfig option.
More information is in the patch.

Thanks,
Michal

The following changes since commit 27ba234c8dfe86c96675d4ef275d1d3c1f5f7053:
   Linus Torvalds (1):
         Merge tag 'tty-3.3-rc1' of git://git.kernel.org/.../gregkh/tty

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (1):
       Revert "microblaze: Add topology init"

  arch/microblaze/kernel/setup.c |   21 +--------------------
  1 files changed, 1 insertions(+), 20 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
