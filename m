Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1FEUqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:46:05 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:36085 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1FEUqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:46:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] media: soc_camera_video_start - type should be const
Date: Sun,  5 Jun 2011 22:45:57 +0200
Message-Id: <1307306757-7068-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/video/soc_camera.c: In function ‘soc_camera_video_start’:
drivers/media/video/soc_camera.c:1515: warning: initialization discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 3988643..4e4d412 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1512,7 +1512,7 @@ static int video_dev_create(struct soc_camera_device *icd)
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
-	struct device_type *type = icd->vdev->dev.type;
+	const struct device_type *type = icd->vdev->dev.type;
 	int ret;
 
 	if (!icd->dev.parent)
-- 
1.7.0.4

