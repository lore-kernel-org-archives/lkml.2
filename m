Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1EKRTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:19:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1EKRTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:19:46 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4] sdio: optimized SDIO IRQ handling for single irq
Date: Wed, 11 May 2011 09:53:35 +0200
Message-Id: <1305100416-5395-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize performance for single irq

Changes since v2.
 * Rebase on mmc-next, change of line numbers no code changes.

Stefan Nilsson XK (1):
  sdio: optimized SDIO IRQ handling for single irq

 drivers/mmc/core/sdio_irq.c |   33 ++++++++++++++++++++++++++++++++-
 include/linux/mmc/card.h    |    1 +
 2 files changed, 33 insertions(+), 1 deletions(-)

-- 
1.7.4.1

