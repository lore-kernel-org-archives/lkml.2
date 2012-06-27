Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2F0Fsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:48:40 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:35949 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2F0Fsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:48:39 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 01:48:39 EDT
Date: Wed, 27 Jun 2012 15:35:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201206270535.q5R5ZhcM009947@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fix for 3.5-rc4
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you plase pull the m68knommu git tree, for-linus branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains a single fix for breakage using the Freescale FEC eth driver
on ColdFire CPUs.

Thanks
Greg




The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:
  Linus Torvalds (1):
        Linux 3.5-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68knommu: define a local devm_clk_get() function

 arch/m68k/platform/coldfire/clk.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
