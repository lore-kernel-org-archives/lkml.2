Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HHUfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 16:35:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45338 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1HHUfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 16:35:34 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2 0/3] ARM: Tegra: Harmony & Seaboard USB and audio
Date: Mon,  8 Aug 2011 14:35:12 -0600
Message-Id: <1312835715-893-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a slight rev of some patches I posted a little while ago, now
in a single series. The second patch has a minor revision that simplifies
board-seaboard-pinmux.c.

The (previous version of the) patches were previously Ack'd by Tegra
maintainers, and Colin asked Arnd to pick them up in arm-soc.git,
although I'm not sure if that request still holds given the merge
window is over?

Stephen Warren (3):
  ARM: Tegra: Harmony: Add USB device
  ARM: Tegra: Seaboard board updates for audio
  ARM: Tegra: Seaboard: Add USB devices

 arch/arm/mach-tegra/board-harmony.c         |    2 +
 arch/arm/mach-tegra/board-seaboard-pinmux.c |    6 ++-
 arch/arm/mach-tegra/board-seaboard.c        |   78 +++++++++++++++++++++++++++
 arch/arm/mach-tegra/board-seaboard.h        |   12 +++--
 4 files changed, 92 insertions(+), 6 deletions(-)

