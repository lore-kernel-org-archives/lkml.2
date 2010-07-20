Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0GTE5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:57:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55234 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0GTE5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=B08wgTx1V1LzTYgjR/BVZZKwyxHyCNuYywr942kO6qQ7G8kNBx8NsHl1q+HAwvX3ZB
         aaoOsqKNjdToeCfKa0Vx71rsfDs759BjFvpnBTQOfNgh4yBxmpIwdbgqAbRvtDUu/vgt
         889X5KidONnw+sLK293dnkYDBNhurJZmKyqh0=
Subject: [PATCH] staging/wlags49_h2: remove unused function prototype
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Henk de Groot <pe1dnn@amsat.org>,
        Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 00:56:54 -0400
Message-ID: <1279601814.25323.3.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With today linux-next I got a compile error in staging/wlags49_h2 driver
due an unused function prototype that use a data type (event_callback_args_t)
that doesn't exist anymore in the pcmcia code.

Current patch solves the issue removing the function prototype.

Thanks a lot.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/wlags49_h2/wl_cs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.h b/drivers/staging/wlags49_h2/wl_cs.h
index a9b8828..21f17be 100644
--- a/drivers/staging/wlags49_h2/wl_cs.h
+++ b/drivers/staging/wlags49_h2/wl_cs.h
@@ -72,8 +72,6 @@ void wl_adapter_insert(struct pcmcia_device *link);
 
 void wl_adapter_release(struct pcmcia_device *link);
 
-int wl_adapter_event(event_t event, int priority, event_callback_args_t *args );
-
 int wl_adapter_init_module( void );
 
 void wl_adapter_cleanup_module( void );
-- 
1.7.0.4



