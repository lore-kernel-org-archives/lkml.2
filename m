Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0I2Uq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:46:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49141 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0I2Uqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:46:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6121"; a="56026019"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/2] msm: defconfig: enable CONFIG_PACKET.
Date: Wed, 29 Sep 2010 13:46:46 -0700
Message-Id: <1285793206-5717-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285793206-5717-1-git-send-email-gbean@codeaurora.org>
References: <1285793206-5717-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable CONFIG_PACKET by default so DHCP will work correctly.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/configs/msm_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 2b8f7af..07bfdd9 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -18,6 +18,7 @@ CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_CMDLINE="mem=64M console=ttyMSM,115200n8"
 CONFIG_PM=y
 CONFIG_NET=y
+CONFIG_PACKET=y
 CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
-- 
1.7.0.4

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
