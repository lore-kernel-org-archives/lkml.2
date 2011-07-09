Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1GIVb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:31:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13415 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab1GIVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:31:53 -0400
Date: Sat, 9 Jul 2011 23:22:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, Andy Lowe <source@mvista.com>
Subject: [PATCH 6/7] drivers/media: static should be at beginning of
 declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107092320450.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-655509267-1310246537=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-655509267-1310246537=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Make sure that the 'static' keywork is at the beginning of declaration
for drivers/media/video/omap/omap_vout.c

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/omap/omap_vout.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 4d07c58..a647894 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -129,7 +129,7 @@ module_param(debug, bool, S_IRUGO);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 /* list of image formats supported by OMAP2 video pipelines */
-const static struct v4l2_fmtdesc omap_formats[] = {
+static const struct v4l2_fmtdesc omap_formats[] = {
 	{
 		/* Note:  V4L2 defines RGB565 as:
 		 *
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-655509267-1310246537=:25516--
