Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1IIBLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:11:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12476 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab1IIBLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864906"
Message-Id: <20110909010918.046564913@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:22 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v3 35/36] Hexagon: Add self to MAINTAINERS
References: <20110909010847.294039464@codeaurora.org>
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
--- linux-hexagon-kernel.orig/MAINTAINERS	2011-09-03 20:14:46.234943567 -0500
+++ linux-hexagon-kernel/MAINTAINERS	2011-09-07 13:00:30.630646332 -0500
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

