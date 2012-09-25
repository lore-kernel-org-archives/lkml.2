Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2IYI5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:57:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55796 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2IYI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:57:47 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, boojin.kim@samsung.com, vinod.koul@intel.com,
        patches@linaro.org, kgene.kim@samsung.com
Subject: [PATCH 0/3] DMA: PL330: Fix mem leaks and balance probe/remove 
Date: Tue, 25 Sep 2012 14:27:33 +0530
Message-Id: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 2 patches of this series fix memory leaks because the memory
allocated for peripheral channels and DMA descriptors were not getting
freed.

The third patch balances the module's remove function.

This patchset is based on slave-dma tree's "next" branch merged with
"fixes" branch and applied patch at [1] to fix the build error.

[1] http://permalink.gmane.org/gmane.linux.kernel.next/24274

Inderpal Singh (3):
  DMA: PL330: Free memory allocated for peripheral channels
  DMA: PL330: Change allocation method to properly free DMA descriptors
  DMA: PL330: Balance module remove function with probe

 drivers/dma/pl330.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

-- 
1.7.9.5

