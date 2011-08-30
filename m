Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1H3TPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:15:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42495 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab1H3TPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113875278"
Message-Id: <20110830190803.029001543@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:08:04 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch v2 35/35] Hexagon: Add self to MAINTAINERS
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=maintainer.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-hexagon-kernel/MAINTAINERS
===================================================================
--- linux-hexagon-kernel.orig/MAINTAINERS	2011-08-30 12:52:36.325009556 -0500
+++ linux-hexagon-kernel/MAINTAINERS	2011-08-30 12:53:00.085050805 -0500
@@ -5279,6 +5279,12 @@
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

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

