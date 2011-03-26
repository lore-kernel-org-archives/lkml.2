Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318Ab1CZBu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:50:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50575 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932402Ab1CZBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:50:26 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX191jI9tv2l1mHRJYszA0lhv7+7mqoMcnUOUzyoOT4
	infzTTNmi4so/X
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 24/27] staging/vt6656: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:49:59 +0100
Message-Id: <1301104202-16592-24-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
References: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a spelling mistake in
drivers/staging/vt6656.

WRONG -> RIGHT
reguest     -> request

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/vt6656/baseband.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0d11147..a3cad36 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1096,7 +1096,7 @@ else {
         pbyAgc = abyVT3184_AGC;
         wLengthAgc = sizeof(abyVT3184_AGC);
 
-        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, reguest by Jack
+        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, request by Jack
         pDevice->abyBBVGA[1] = 0x10;
         pDevice->abyBBVGA[2] = 0x0;
         pDevice->abyBBVGA[3] = 0x0;
-- 
1.7.3.4

