Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0LIUyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:54:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47080 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LIUyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:54:54 -0500
Date: Thu, 9 Dec 2010 12:54:50 -0800
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, Jordan Crouse <jordan@cosmicpenguin.net>,
        linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org,
        cjb@laptop.org
Subject: [PATCH] MAINTAINERS: update geode entry
Message-ID: <20101209125450.6bb141f0@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove Jordan as the geode maintainer (he's not been interested in geode for
some time), and add myself as the maintainer.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..90c5e3e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -405,7 +405,7 @@ S:	Supported
 F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
-P:	Jordan Crouse
+P:	Andres Salomon <dilinger@queued.net>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
-- 
1.7.2.3

