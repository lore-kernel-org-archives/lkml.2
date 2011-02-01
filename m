Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1BAH6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:58:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53507 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1BAH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:58:46 -0500
Message-ID: <4D47BD31.6000608@monstr.eu>
Date: Tue, 01 Feb 2011 08:58:41 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 2.6.38-rc4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following bug fixes for microblaze.

Thanks,
Michal

The following changes since commit 1f0324caefd39985e9fe052fac97da31694db31e:
   Linus Torvalds (1):
         Merge branch 'stable/bug-fixes-rc2' of git://git.kernel.org/.../konrad/xen

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (3):
       microblaze: Fix DTB passing from bootloader
       microblaze: Fix unaligned issue on MMU system with BS=0 DIV=1
       microblaze: Fix ASM optimized code for LE

  arch/microblaze/kernel/head.S                 |   14 ++++++++++++--
  arch/microblaze/kernel/hw_exception_handler.S |    4 ----
  arch/microblaze/lib/fastcopy.S                |    4 ++++
  3 files changed, 16 insertions(+), 6 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
