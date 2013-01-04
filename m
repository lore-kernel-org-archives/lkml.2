Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3ADJyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:54:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46539 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab3ADJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:54:34 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lrg@ti.com>, <perex@perex.cz>, <nsekhar@ti.com>,
        <gururaja.hebbar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: [PATCH V2 0/2] ARM/ASoC: Davinci: Device Tree Update
Date: Fri, 4 Jan 2013 15:24:35 +0530
Message-ID: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Add pinctrl for McASP Module
2. Add DT support for Davinci machine platform

This patch-set is tested on Davinci platform (DA850 EVM). This series applies on
top of tag next-20130103 git tree
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

These patches cannot be tested directly on mainline kernel (DT based).
This is because dma is not yet completely ported to Davinci ASoC. I had to add
few hacks to get Audio working on Davinci DA850 platform.

For reference, I have placed the entire working tree @ 
Tree : https://gitorious.org/davinci-asoc-dt/davinci-asoc-dt
Branch : dev_next-20130103_davinci_asoc_dt

Changes in V2
	 - Remove reference to Linux & software details from DT binding

Hebbar, Gururaja (2):
  ASoC: davinci-mcasp: Add pinctrl support
  ASoC: Davinci: machine: Add device tree binding

 .../bindings/sound/davinci-evm-audio.txt           |   53 ++++++
 sound/soc/davinci/davinci-evm.c                    |  179 +++++++++++++++++---
 sound/soc/davinci/davinci-mcasp.c                  |    7 +
 3 files changed, 219 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/davinci-evm-audio.txt

-- 
1.7.9.5

