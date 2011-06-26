Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1FZVc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:32:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1FZVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:32:04 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 0/2] dmaengine/ste_dma40: Fix implementation of issue_pending
Date: Sun, 26 Jun 2011 23:29:51 +0200
Message-Id: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolve issue pending TOOD for ste_dma40

Per Forlin (2):
  dmaengine/ste_dma40: add a separate queue for pending requests
  dmaengine: remove ste_dma40 from issue_pending TODO

 drivers/dma/TODO        |    1 -
 drivers/dma/ste_dma40.c |   26 ++++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

-- 
1.7.4.1

