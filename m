Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0FVHpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:45:49 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34523 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab0FVHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:45:47 -0400
Date: Tue, 22 Jun 2010 16:45:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.35-rc4
Message-ID: <20100622074525.GA20140@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-linus

Which contains:

Huang Weiyi (1):
      sh: remove duplicated #include

Julia Lawall (1):
      arch/sh/mm: Eliminate a double lock

Paul Mundt (2):
      sh: Fix up IORESOURCE_PCI_FIXED usage in pcibios_fixup_device_resources().
      clocksource: sh_cmt: Fix up bogus shift value.

 arch/sh/boards/mach-ecovec24/setup.c |    1 -
 arch/sh/drivers/pci/pci.c            |    2 --
 arch/sh/mm/pmb.c                     |    2 +-
 drivers/clocksource/sh_cmt.c         |    2 +-
 4 files changed, 2 insertions(+), 5 deletions(-)
