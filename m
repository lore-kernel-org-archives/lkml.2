Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1JSEFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:05:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab1JSEFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:05:48 -0400
Message-Id: <093448$3qutot@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6503"; a="128939805"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Tue, 18 Oct 2011 22:48:06 -0500
Subject: [PATCH v5 35/36] Hexagon: Add self to MAINTAINERS
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
