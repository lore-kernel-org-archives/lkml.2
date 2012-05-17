Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535Ab2EQKW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:22:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36731 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab2EQKWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:22:25 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <mturquette@ti.com>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH 0/2] clk: Add support for more default divider types
Date: Thu, 17 May 2012 15:52:12 +0530
Message-ID: <1337250134-29206-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

The 2 patches here add support for 'power of two' and 'table based'
dividers to clk-divider.c.
These divider types are useful on OMAP and extending clk-divider.c
to support these should help other platforms too which have
such divider types.

regards,
Rajendra

Rajendra Nayak (2):
  clk: Add support for power of two type dividers
  clk: Add support for rate table based dividers

 drivers/clk/clk-divider.c    |  129 +++++++++++++++++++++++++++++++++++-------
 include/linux/clk-private.h  |    3 +-
 include/linux/clk-provider.h |   10 +++-
 3 files changed, 120 insertions(+), 22 deletions(-)

