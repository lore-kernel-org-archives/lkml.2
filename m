Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1EDQGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:06:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35764 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1EDQGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:06:11 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2] sdio: optimized SDIO IRQ handling for single irq
Date: Wed,  4 May 2011 18:06:00 +0200
Message-Id: <1304525161-14448-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize performance for single irq

Changes since v1.
 * Add member to hold sdio_single_irq function in mmc_card and
   minimize new code in process_sdio_pending_irqs
 * Clarify commit message

Stefan Nilsson XK (1):
  sdio: optimized SDIO IRQ handling for single irq

 drivers/mmc/core/sdio_irq.c |   30 ++++++++++++++++++++++++++++++
 include/linux/mmc/card.h    |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

-- 
1.7.4.1
