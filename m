Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab2AIPMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:12:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11214 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2AIPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:12:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 09 Jan 2012 07:12:29 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "open list:TEGRA SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] Tegra30 clockframework
Date: Mon, 9 Jan 2012 17:12:10 +0200
Message-ID: <1326121937-32054-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces the tegra30 clockframework. Clocks which require
voltage scaling are not included in this version. The implementation doesn't
use the generic clock code yet. It's the intention to move to it, once the
semantics are fully clarified.

---

Changes in v2:
 * Fix parent clocks for TWD. This makes the SMP configuration booting again.

Peter De Schrijver (3):
  ARM: tegra: add support for new clock framework features
  ARM: tegra: implement basic tegra30 clock framework
  ARM: tegra: enable tegra30 clock framework

 arch/arm/mach-tegra/Makefile           |    1 +
 arch/arm/mach-tegra/clock.c            |   22 +
 arch/arm/mach-tegra/clock.h            |   15 +
 arch/arm/mach-tegra/common.c           |    1 +
 arch/arm/mach-tegra/include/mach/clk.h |   10 +
 arch/arm/mach-tegra/tegra30_clocks.c   | 3099 ++++++++++++++++++++++++++++++++
 6 files changed, 3148 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra30_clocks.c

-- 
1.7.7.rc0.72.g4b5ea.dirty

