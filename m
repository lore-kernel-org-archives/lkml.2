Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1LOFJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:09:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59359 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1LOFJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:09:51 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-e0-4ee9811db518
Date: Thu, 15 Dec 2011 14:10:13 +0900
From: Kyungmin Park <kmpark@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, myungjoo.ham@gmail.com
Subject: [PATCH] devfreq: Add devfreq maintainer entry
Message-id: <20111215051013.GA23030@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

As devfreq is merged at mainline. Also update the maintainer entry.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index b9db108..a5d2840 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2192,6 +2192,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/dwc3/
 
+DEVICE FREQUENCY (DEVFREQ)
+M:	MyungJoo Ham <myungjoo.ham@samsung.com>
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/devfreq/
+
 DEVICE NUMBER REGISTRY
 M:	Torben Mathiasen <device@lanana.org>
 W:	http://lanana.org/docs/device-list/index.html
