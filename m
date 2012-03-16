Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032959Ab2CPPmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:42:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31196 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2CPPmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:42:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 16 Mar 2012 16:42:10 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH v2 0/2] [media] s5p-tv: Add initial DT-support to s5p-tv's
 subdevices
To: t.stanislaws@samsung.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1331912532-7798-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
 - dropped patch for sii9234 driver - driver itself hasn't been merged yet
 - changed compatible string to name first known SoC having given features
   (IP blocks, actually) [Thanks Thomas!]


This patchset adds initial device tree support to drivers used by
s5p-tv on Exynos4.

DT support for s5p-tv driver itself would benefit from changes to v4l
core (missing OF helper functions) and thus, will be sent later in
separate patchset.

Karol Lewandowski (2):
  s5p-tv: Add initial DT-support for TV mixer
  s5p-tv: Add initial DT-support for HDMIPHY

 drivers/media/video/s5p-tv/hdmiphy_drv.c |   10 ++++++++++
 drivers/media/video/s5p-tv/mixer_drv.c   |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

-- 
1.7.9

