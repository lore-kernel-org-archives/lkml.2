Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2LQLXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:23:30 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:43403 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2LQLX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:23:29 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <broonie@opensource.wolfsonmicro.com>, <voice.shen@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/3] at91/ssc: fixes on ASoC tree for 3.8
Date: Mon, 17 Dec 2012 12:23:23 +0100
Message-ID: <cover.1355742707.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

This series goes on top of current Linus' git tree and fixes an error that
we have while compiling DTBs for AT91:
ERROR (phandle_references): Reference to non-existent node or label
"pinctrl_ssc0_tx"

ERROR: Input tree has errors, aborting (use -f to force output)
make[3]: *** [arch/arm/boot/dts/at91sam9g20ek.dtb] Error 2

I have included pending material that is dealing with SSC and pinctrl. The
pinctrl part can be merged more easily now that the big pinctrl update for AT91
has been merged upstream.
I have also included a typo patch that you have already taken as 315656b (ASoC:
atmel-ssc: change disable to disable in dts node) in your topic/atmel branch
but that was not described properly.

If you find it easier, I can provide you a git tree for this material: just
tell me...

Thanks for your help, best regards,


Bo Shen (3):
  ARM: at91/dts: fix typo in SSC status property
  ARM: at91/dts: add pinctrl support for SSC peripheral
  ASoC: atmel-ssc: add pinctrl selection to driver

 arch/arm/boot/dts/at91sam9260.dtsi | 18 +++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi | 40 ++++++++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9g45.dtsi | 40 ++++++++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9n12.dtsi | 26 +++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 32 +++++++++++++++++++++++-------
 drivers/misc/atmel-ssc.c           |  8 ++++++++
 6 files changed, 153 insertions(+), 11 deletions(-)

-- 
1.8.0

