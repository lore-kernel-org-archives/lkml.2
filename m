Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab0KOVGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:06:22 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52877 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0KOVGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:06:21 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19LoYDLsOCFck0Ql73bRjZx
Date: Mon, 15 Nov 2010 13:06:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for 2.6.37-rc1
Message-ID: <20101115210613.GM9264@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some trivial omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4:

  Linux 2.6.37-rc1 (2010-11-01 07:54:12 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Felipe Balbi (1):
      arm: omap1: devices: need to return with a value

Janusz Krzysztofik (1):
      OMAP1: camera.h: add missing include

Mathias Nyman (1):
      omap: dma: Add read-back to DMA interrupt handler to avoid spuriousinterrupts

Thomas Weber (1):
      OMAP2: Devkit8000: Fix mmc regulator failure

 arch/arm/mach-omap1/devices.c             |    5 ++---
 arch/arm/mach-omap1/include/mach/camera.h |    2 ++
 arch/arm/mach-omap2/board-devkit8000.c    |    3 ---
 arch/arm/plat-omap/dma.c                  |    2 ++
 4 files changed, 6 insertions(+), 6 deletions(-)
