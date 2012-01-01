Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2AAOim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 09:38:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2AAOij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 09:38:39 -0500
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, eric.miao@linaro.org, patches@linaro.org
Subject: [PATCH v2 0/2] imx-sdma: memory barrier fix 
Date: Sun,  1 Jan 2012 22:38:10 +0800
Message-Id: <1325428692-11473-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
 - add "let sdma_run_channel call sdma_enable_channel"

[PATCH v2 1/2] dma/imx-sdma: let sdma_run_channel call sdma_enable_channel
[PATCH v2 2/2] dma/imx-sdma: add wmb before enable a channel

Thanks
Richard
