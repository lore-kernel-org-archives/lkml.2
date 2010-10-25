Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0JYNbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:31:20 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:44144 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0JYNbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:31:19 -0400
Date: Mon, 25 Oct 2010 15:30:03 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless/wl1271: remove redundant if-statement v2
Message-ID: <20101025153003.3aa7c168@absol.kitzblitz>
In-Reply-To: <1288012245.21130.24.camel@chilepepper>
References: <20101025000744.17f7086e@absol.kitzblitz>
	<4CC4B210.2010608@lwfinger.net>
	<1288012245.21130.24.camel@chilepepper>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wl1271_ps_elp_sleep() is void and cannot return a value.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Sorry for the poor wording of the initial description.

 drivers/net/wireless/wl12xx/wl1271_event.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 7b3f503..38ccef7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -134,8 +134,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		/* go to extremely low power mode */
 		wl1271_ps_elp_sleep(wl);
-		if (ret < 0)
-			break;
 		break;
 	case EVENT_EXIT_POWER_SAVE_FAIL:
 		wl1271_debug(DEBUG_PSM, "PSM exit failed");
-- 
1.7.2.2
