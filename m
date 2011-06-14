Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1FNB6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:58:14 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:23648 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1FNB6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:58:12 -0400
Date: Tue, 14 Jun 2011 12:00:11 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201106140200.p5E20BTn013012@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>
Subject: [git pull] m68knommu bug fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus-fixes branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus-fixes

A couple of bug fixes. One for linker scripts changes, and the other to
not rely on m68k-linux compiler machine type defines.

Thanks
Greg




The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:
  Linus Torvalds (1):
        Linux 3.0-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus-fixes

Greg Ungerer (3):
      m68knommu: fix linker script exported name sections
      m68knommu: create config options for CPU classes
      m68k: use kernel processor defines for conditional optimizations

 arch/m68k/Kconfig.nommu           |   52 ++++++++++++++++++++++++++++++++-----
 arch/m68k/kernel/m68k_ksyms.c     |    3 +-
 arch/m68k/kernel/vmlinux.lds_no.S |   20 +++++++-------
 arch/m68k/lib/memcpy.c            |    9 +++---
 arch/m68k/lib/memset.c            |    9 +++---
 arch/m68k/lib/muldi3.c            |   21 +++++++--------
 6 files changed, 74 insertions(+), 40 deletions(-)
