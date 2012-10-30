Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2J3Jan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:30:43 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52557 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756382Ab2J3JaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:30:23 -0400
From: yongd <yongd@marvell.com>
To: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: zhangfei.gao@marvell.com, kevin.liu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/3] mmc: remove MMC_CAP_NEEDS_POLL setting in sdhci_add_host
Date: Tue, 30 Oct 2012 17:30:00 +0800
Message-Id: <1351589403-26398-1-git-send-email-yongd@marvell.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 30 Oct 2012 09:30:00.0504 (UTC) FILETIME=[223C8380:01CDB681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
Sorry for my so late. And eventually these updated patches are here for your
review. Thanks in advance.
For patch 1, add SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for ESDHC_CD_GPIO type,
or the host controller detection interrupts will be redundantly enabled. And its
comment is correspondingly updated.
For patch 2, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for all detection
types except S3C_SDHCI_CD_INTERNAL. Then also update the comment.
For patch 3, no update.

