Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0DGRPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:15:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab0DGRPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:15:21 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] davinci fixes for 2.6.34-rc
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 07 Apr 2010 10:15:18 -0700
Message-ID: <876343dw0p.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following fixes for 2.6.34-rc.

Thanks,

Kevin


The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
  Linus Torvalds (1):
        Linux 2.6.34-rc3

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-fixes-for-linus

Brian Niebuhr (1):
      davinci: edma: clear events in edma_start()

Kevin Hilman (2):
      davinci: timers: don't enable timer until clocksource is initialized
      davinci: DM365: fix duplicate default IRQ priorities

Sekhar Nori (1):
      davinci: da8xx/omap-l1: fix build error when CONFIG_DAVINCI_MUX is undefined

Sergei Shtylyov (1):
      davinci: fix compile warning: <mach/da8xx.h>: #include <linux/platform_device.h>

 arch/arm/mach-davinci/dm365.c              |    1 -
 arch/arm/mach-davinci/dma.c                |    3 ++-
 arch/arm/mach-davinci/include/mach/da8xx.h |    8 +++++++-
 arch/arm/mach-davinci/time.c               |    6 ++++--
 4 files changed, 13 insertions(+), 5 deletions(-)
