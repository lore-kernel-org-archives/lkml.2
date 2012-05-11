Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2EKFOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:14:54 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:12595 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2EKFOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:14:52 -0400
Date: Fri, 11 May 2012 15:12:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201205110512.q4B5CnJR030104@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu fixes for 3.4
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains a single fix for including the ColdFire QSPI interface setup
code when enabled as a module. This was broken in the consolidation of the
ColdFire SoC device tables in the 3.4 merge window.

Thanks
Greg



The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:
  Linus Torvalds (1):
        Linux 3.4-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Steven King (1):
      m68knommu: enable qspi support when SPI_COLDFIRE_QSPI = m

 arch/m68k/platform/520x/config.c     |    6 +++---
 arch/m68k/platform/523x/config.c     |    6 +++---
 arch/m68k/platform/5249/config.c     |    6 +++---
 arch/m68k/platform/527x/config.c     |    6 +++---
 arch/m68k/platform/528x/config.c     |    6 +++---
 arch/m68k/platform/532x/config.c     |    6 +++---
 arch/m68k/platform/coldfire/device.c |    6 +++---
 7 files changed, 21 insertions(+), 21 deletions(-)
