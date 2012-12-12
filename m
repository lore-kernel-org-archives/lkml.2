Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab2LLJhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:37:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52124 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LLJhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:37:43 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/7] various ste_dma40 fixes
Date: Wed, 12 Dec 2012 10:37:14 +0100
Message-Id: <1355305041-2338-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this patch set contains some fixes for the ste_dma40 driver.

Thanks,
Fabio


Gerald Baeza (1):
  dmaengine: ste_dma40: support fixed physical channel allocation

Narayanan (1):
  dmaengine: ste_dma40: reset priority bit for logical channels

Narayanan G (1):
  dmaengine: ste_dma40: don't check for pm_runtime_suspended()

Per Forlin (3):
  dmaengine: ste_dma40: use writel_relaxed for lcxa
  dmaengine: ste_dma40: set dma max seg size
  dmaengine: ste_dma40: limit burst size to 16

Rabin Vincent (1):
  dmaengine: ste_dma40: don't allow high priority dest event lines

 drivers/dma/ste_dma40.c    | 46 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/dma/ste_dma40_ll.c | 27 ++++++++++++++-------------
 2 files changed, 55 insertions(+), 18 deletions(-)

-- 
1.7.12.1

