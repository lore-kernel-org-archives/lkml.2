Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2KVSqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55798 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2KVSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:45:59 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <perex@perex.cz>, <nsekhar@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: [PATCH 0/2] ARM/ASoC: Davinci: Device Tree Update
Date: Thu, 22 Nov 2012 09:34:57 +0530
Message-ID: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>

1. Add pinctrl for McASP Module
2. Add DT support for Davinci machine platform (resend)

Second commit is a resend after re-basing on latest broonie-asoc/for-next
(v3.7-rc6)

Hebbar, Gururaja (2):
  ASoC: davinci-mcasp: Add pinctrl support
  ASoC: Davinci: machine: Add device tree binding

 .../bindings/sound/davinci-evm-audio.txt           |   66 +++++++
 sound/soc/davinci/davinci-evm.c                    |  185 +++++++++++++++++---
 sound/soc/davinci/davinci-mcasp.c                  |    7 +
 3 files changed, 238 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/davinci-evm-audio.txt

-- 
1.7.9.5

