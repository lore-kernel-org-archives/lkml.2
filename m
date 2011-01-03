Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1ACQjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:39:35 -0500
Received: from sd-11162.dedibox.fr ([88.191.70.230]:35494 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab1ACQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:39:34 -0500
Date: Mon, 3 Jan 2011 17:39:32 +0100
From: Stelian Pop <stelian@popies.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Orphan the meye driver since I no longer have the hardware
Message-ID: <20110103163932.GC7475@calypso>
Reply-To: Stelian Pop <stelian@popies.net>
Mail-Followup-To: Stelian Pop <stelian@popies.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't even remember when it was that I sold this laptop, but
it has been a few years...

Signed-off-by: Stelian Pop <stelian@popies.net>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61d8c41..ca8ea6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3962,9 +3962,8 @@ F:	include/linux/module.h
 F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
-M:	Stelian Pop <stelian@popies.net>
 W:	http://popies.net/meye/
-S:	Maintained
+S:	Orphan
 F:	Documentation/video4linux/meye.txt
 F:	drivers/media/video/meye.*
 F:	include/linux/meye.h
-- 
1.7.1
