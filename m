Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1EETOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:14:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41961 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1EETOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:14:49 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3] sdio: optimized SDIO IRQ handling for single irq
Date: Thu,  5 May 2011 21:14:02 +0200
Message-Id: <1304622843-5123-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize performance for single irq

Changes since v2.
 * Clarify comment in process_sdio_pending_irqs
 * Simplify sdio_single_irq if-condition

Stefan Nilsson XK (1):
  sdio: optimized SDIO IRQ handling for single irq

 drivers/mmc/core/sdio_irq.c |   33 ++++++++++++++++++++++++++++++++-
 include/linux/mmc/card.h    |    1 +
 2 files changed, 33 insertions(+), 1 deletions(-)

-- 
1.7.4.1

