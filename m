Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2AQSBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:01:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2AQSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:01:52 -0500
Message-ID: <4F15B78A.2090700@monstr.eu>
Date: Tue, 17 Jan 2012 19:01:46 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 3.3 fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two following two patches to your tree.

The first patch init topology and fix problem with default microblaze configuration
and the second is out of tree NO_IRQ patch for xilinx ehci driver.
I have also got ACK from Alan Stern (USB ehci driver maintainer).

Thanks,
Michal

The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:
   Linus Torvalds (1):
         Merge tag 'for-linus' of git://git.kernel.org/.../mst/vhost

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (2):
       microblaze: Add topology init
       USB: EHCI: Don't use NO_IRQ in xilinx ehci driver

  arch/microblaze/kernel/setup.c    |   21 ++++++++++++++++++++-
  drivers/usb/host/ehci-xilinx-of.c |    2 +-
  2 files changed, 21 insertions(+), 2 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
