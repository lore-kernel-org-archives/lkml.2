Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1F0Je5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:34:57 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:44275 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153Ab1F0Jd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:33:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        om prakash <omprakash.pal@stericsson.com>
Subject: [PATCH 0/4] DMA40 patches for 3.1
Date: Mon, 27 Jun 2011 11:33:10 +0200
Message-ID: <1309167190-23295-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a few ST-Ericsson incremental internal patches to the DMA40 driver
that I extracted, and added a consolidation patch on top. Currently the
only major missing piece is runtime PM.

Linus Walleij (1):
  dmaengine/ste_dma40: use AMBA PrimeCell helper macros

Rabin Vincent (1):
  dmaengine/ste_dma40: allow memory buswidth/burst to be configured

Robert Marklund (1):
  dmaengine/ste_dma40: make the cyclic alloc NOWAIT

Om Prakash (1):
  dmaengine/ste_dma40: fix missing kernel-doc

 drivers/dma/ste_dma40.c    |  244 ++++++++++++++++++++++++--------------------
 drivers/dma/ste_dma40_ll.h |    3 -
 2 files changed, 131 insertions(+), 116 deletions(-)

-- 
1.7.3.2

