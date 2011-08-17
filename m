Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1HQRHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:07:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18298 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1HQRGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:06:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="111004341"
Message-Id: <20110817163523.224839138@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:35:33 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 36/36] Hexagon: Add self to MAINTAINERS
References: <20110817163457.878854582@codeaurora.org>
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
--- linux-hexagon-kernel.orig/MAINTAINERS	2011-08-15 15:21:56.663753077 -0500
+++ linux-hexagon-kernel/MAINTAINERS	2011-08-15 15:22:32.453781219 -0500
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

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

