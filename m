Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2KVS4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2KVS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:27 -0500
Date: Wed, 21 Nov 2012 15:28:54 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.7
Message-ID: <20121121232854.GB18134@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 65546ab097b023886a60df4cbc931d4cc362b98e:

  Merge tag 'omap-for-v3.7-rc5/fixes-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2012-11-21 13:56:36 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.7

A few more fixes for final 3.7. Two dealing with pinmux setup on OMAP, and
one dealing with TV output on DaVinci. And one small MAINTAINER update.

----------------------------------------------------------------
Anders Hedlund (1):
      ARM: OMAP3: igep0020: Set WIFI/BT GPIO pins in correct mux mode

Javier Martinez Canillas (1):
      ARM: OMAP: Add maintainer entry for IGEP machines

Kevin Hilman (1):
      ARM: OMAP4: TWL: mux sys_drm_msecure as output for PMIC

Lad, Prabhakar (1):
      ARM: davinci: dm644x: fix out range signal for ED

Olof Johansson (2):
      Merge tag 'davinci-fixes-for-v3.7' of git://gitorious.org/linux-davinci/linux-davinci into fixes
      Merge tag 'omap-for-v3.7-rc5/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes

 MAINTAINERS                          | 8 ++++++++
 arch/arm/mach-davinci/dm644x.c       | 3 +--
 arch/arm/mach-omap2/board-igep0020.c | 5 +++++
 arch/arm/mach-omap2/twl-common.c     | 1 +
 4 files changed, 15 insertions(+), 2 deletions(-)
