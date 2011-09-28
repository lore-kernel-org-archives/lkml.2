Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1I1BFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:05:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7077 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1I1BFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:05:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 27 Sep 2011 18:05:09 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v4 0/3] Add support for tegra2 based ventana board
Date: Wed, 28 Sep 2011 04:04:59 +0300
Message-ID: <1317171902-14736-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the tegra2 based ventana development board.

Boot tested on ventana.                                                                                                                               

Now finally without Change-IDs I hope...

Peter De Schrijver (3):
  arm/tegra: prepare Seaboard pinmux code for derived boards
  arm/tegra: add support for ventana pinmuxing
  arm/tegra: device tree support for ventana board

 arch/arm/boot/dts/tegra-ventana.dts         |   32 ++++++++++++++
 arch/arm/mach-tegra/Kconfig                 |    6 +++
 arch/arm/mach-tegra/Makefile                |    1 +
 arch/arm/mach-tegra/Makefile.boot           |    1 +
 arch/arm/mach-tegra/board-dt.c              |    5 ++-
 arch/arm/mach-tegra/board-seaboard-pinmux.c |   63 ++++++++++++++++++++++++---
 6 files changed, 101 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra-ventana.dts

