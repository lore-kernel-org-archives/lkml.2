Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413Ab1CZBui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:50:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50779 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934363Ab1CZBuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:50:32 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/qQnR7SBnqGuj02ejRoreL/TjnKfEH89+4J0w/Fj
	AyKGp4wdwCDHsM
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 27/27] staging/brcm80211: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:50:02 +0100
Message-Id: <1301104202-16592-27-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
References: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/brcm80211.

WRONG -> RIGHT
reqest	-> request

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/wlan-ng/p80211req.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211req.c b/drivers/staging/wlan-ng/p80211req.c
index 179194e..d540e47 100644
--- a/drivers/staging/wlan-ng/p80211req.c
+++ b/drivers/staging/wlan-ng/p80211req.c
@@ -80,7 +80,7 @@ static int p80211req_mibset_mibget(wlandevice_t *wlandev,
 /*----------------------------------------------------------------
 * p80211req_dorequest
 *
-* Handles an MLME reqest/confirm message.
+* Handles an MLME request/confirm message.
 *
 * Arguments:
 *	wlandev		WLAN device struct
-- 
1.7.3.4

