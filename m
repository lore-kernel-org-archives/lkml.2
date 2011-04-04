Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1DDH2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:28:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49299 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1DDH2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:28:06 -0400
Message-ID: <4D997300.8060906@monstr.eu>
Date: Mon, 04 Apr 2011 09:28:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze changes for 2.6.39-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fixes for microblaze.

Thanks,
Michal


The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:
   Linus Torvalds (1):
         Linux 2.6.39-rc1

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git next

Michal Simek (3):
       microblaze: Fix level/edge irq sensibility
       microblaze: Wire up new syscalls
       microblaze: Fix ftrace

  arch/microblaze/include/asm/unistd.h   |    6 +++++-
  arch/microblaze/kernel/Makefile        |    1 +
  arch/microblaze/kernel/ftrace.c        |   10 ++++++----
  arch/microblaze/kernel/intc.c          |    4 ++--
  arch/microblaze/kernel/syscall_table.S |    4 ++++
  arch/microblaze/lib/Makefile           |    6 ++++++
  6 files changed, 24 insertions(+), 7 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
