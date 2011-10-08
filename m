Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1JHUEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:04:40 -0400
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23]:55454 "EHLO
	blu0-omc1-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab1JHUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:04:39 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Oct 2011 16:04:39 EDT
X-Originating-IP: [86.28.179.214]
X-Originating-Email: [jake5991@live.com]
Message-ID: <BLU0-SMTP9072E77C5346BC9ADCE223A2FF0@phx.gbl>
From: JAke Burton <jake5991@live.com>
To: gregkh@suse.de
CC: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jake Burton <jake5991@live.com>
Subject: [PATCH 2/2] Staging: comedi: fix brace coding and whitespace issue in ni_atmio.c
Date: Sat, 8 Oct 2011 20:58:22 +0100
X-Mailer: git-send-email 1.7.4.1
Signed-off-by: Jake Burton <jake5991@live.com>
X-OriginalArrivalTime: 08 Oct 2011 19:58:28.0350 (UTC) FILETIME=[A59631E0:01CC85F4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ni_atmio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index e6c6c72..91e270a 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -279,7 +279,9 @@ static const int ni_irqpin[] = {
 
 struct ni_private {
 	struct pnp_dev *isapnp_dev;
-NI_PRIVATE_COMMON};
+	NI_PRIVATE_COMMON
+};
+
 #define devpriv ((struct ni_private *)dev->private)
 
 /* How we access registers */
-- 
1.7.4.1

