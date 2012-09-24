Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2IXOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:43:44 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:46670 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755921Ab2IXOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:43:42 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 0/3] clk: ux500: Set sdmmc clock to 100MHz
Date: Mon, 24 Sep 2012 16:43:16 +0200
Message-ID: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

The reason behind this change is that we would like to enable all
the mmc/sd/sdio features from a hardware perspective (ARM PL18x).
It is then required that the frequency must be 100MHz.

Ulf Hansson (3):
  mfd: dbx500: Export prmcu_request_ape_opp_100_voltage
  clk: ux500: Support prcmu ape opp voltage clock
  clk: ux500: Update sdmmc clock to 100MHz for u8500

 drivers/clk/ux500/clk-prcmu.c    |   55 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/ux500/clk.h          |    6 +++++
 drivers/clk/ux500/u8500_clk.c    |    5 ++--
 drivers/mfd/db8500-prcmu.c       |    4 +--
 include/linux/mfd/db8500-prcmu.h |    4 +--
 include/linux/mfd/dbx500-prcmu.h |   10 +++++++
 6 files changed, 78 insertions(+), 6 deletions(-)

-- 
1.7.10

