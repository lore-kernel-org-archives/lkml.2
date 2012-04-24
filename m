Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2DXB3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:29:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37786 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2DXB3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:29:42 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: Remove unused variable "tmp" from function mxl111sf_ep6_streaming_ctrl.
Date: Tue, 24 Apr 2012 02:29:37 +0100
Message-Id: <1335230977-14327-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to address the following warning during compilation time:

  drivers/media/dvb/dvb-usb/mxl111sf.c: In function ‘mxl111sf_ep6_streaming_ctrl’:
  drivers/media/dvb/dvb-usb/mxl111sf.c:343: warning: unused variable ‘tmp’

This variable is indeed no longer in use (change can be traced back
to commit: 3be5bb71fbf18f83cb88b54a62a78e03e5a4f30a).

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/media/dvb/dvb-usb/mxl111sf.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/dvb/dvb-usb/mxl111sf.c
index 81305de..91834c5 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -340,7 +340,6 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	struct mxl111sf_state *state = d->priv;
 	struct mxl111sf_adap_state *adap_state = adap->fe_adap[adap->active_fe].priv;
 	int ret = 0;
-	u8 tmp;
 
 	deb_info("%s(%d)\n", __func__, onoff);
 
-- 
1.7.7.1

