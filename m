Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1BFVxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:53:35 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23055 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1BFVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:53:33 -0500
Date: Sun, 6 Feb 2011 22:52:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Arend van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>, trivial@kernel.org
Subject: [PATCH][trivial] Remove duplicate inclusion of wlc_event.h in
 drivers/staging/brcm80211/sys/wlc_mac80211.c
Message-ID: <alpine.LNX.2.00.1102062249180.13593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We include wlc_event.h twice in 
drivers/staging/brcm80211/sys/wlc_mac80211.c
Once is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 wlc_mac80211.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index a130386..0a46d44 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -47,7 +47,6 @@
 #include <wlc_antsel.h>
 #include <wlc_stf.h>
 #include <wlc_ampdu.h>
-#include <wlc_event.h>
 #include <wl_export.h>
 #include "d11ucode_ext.h"
 #include <wlc_alloc.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

