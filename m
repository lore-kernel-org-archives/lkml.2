Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab2DYV50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:57:26 -0400
Received: from mail.grid-net.com ([97.65.115.2]:29704 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab2DYV5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:57:24 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 17:57:24 EDT
From: Subodh Nijsure <snijsure@grid-net.com>
To: <rdunlap@xenotime.net>, <linux-doc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <snijsure@grid-net.com>
Subject: [PATCH] Recommend correct way to submit new version of the patches.
Date: Wed, 25 Apr 2012 14:51:57 -0700
Message-ID: <1335390717-32165-1-git-send-email-snijsure@grid-net.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.0.120]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King suggested proper way to submit new versions of the patches.
See http://lists.infradead.org/pipermail/linux-arm-kernel/2012-April/096236.html
Modify SubmittingPatches to summerize that recommendation.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
---
 Documentation/SubmittingPatches |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 4468ce2..4b166a4 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -579,6 +579,18 @@ use diffstat options "-p 1 -w 70" so that filenames are listed from
 the top of the kernel source tree and don't use too much horizontal
 space (easily fit in 80 columns, maybe with some indentation).
 
+Please don't thread the posting of a new version of the patches to
+the previous posting of the older version.  In other words, the
+initial summary mail for Vn should not be threaded to the Vn-1
+series, and the individual patches for Vn should only be threaded
+to the initial summary mail for Vn. This is to avoid one massive
+thread for a proposed patch.
+
+If you wish to provide a direct reference back to a previous thread,
+please do so via URLs into archives, or providing the message id or
+exact subject of the previous series in the new summary message body.
+But please don't thread each version to the previous version!
+
 See more details on the proper patch format in the following
 references.
 
-- 
1.7.5.4

