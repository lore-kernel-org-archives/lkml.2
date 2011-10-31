Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1KAASw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:18:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60416 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934847Ab1KAASQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:18:16 -0400
Message-Id: <093448$3uejvt@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599805"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:56:38 -0500
Subject: [PATCH v5 35/36] Hexagon: Add self to MAINTAINERS
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ace8f9c..94a73fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5288,6 +5288,12 @@ F:	fs/qnx4/
 F:	include/linux/qnx4_fs.h
 F:	include/linux/qnxtypes.h
 
+QUALCOMM HEXAGON ARCHITECTURE
+M:	Richard Kuo <rkuo@codeaurora.org>
+L:	linux-hexagon@vger.kernel.org
+S:	Supported
+F:	arch/hexagon/
+
 RADOS BLOCK DEVICE (RBD)
 F:	include/linux/qnxtypes.h
 M:	Yehuda Sadeh <yehuda@hq.newdream.net>
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
