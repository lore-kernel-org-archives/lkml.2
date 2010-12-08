Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0LHWpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:45:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54641 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753406Ab0LHWpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:45:11 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/a0ix7mHjauj4PAIwEZec7ATHmefKqiHRIUfw/L9
	zAUQjVSoslyYPr
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        William Hubbs <w.d.hubbs@gmail.com>, Dan Carpenter <error27@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/speakup: fix buildfailure by removing odd closing parenthesis
Date: Wed,  8 Dec 2010 23:45:06 +0100
Message-Id: <1291848306-31620-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a simple buildfailure by removing an odd closing parenthesis

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/speakup/fakekey.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/speakup/fakekey.c b/drivers/staging/speakup/fakekey.c
index 9f2a7a1..1b34a87 100644
--- a/drivers/staging/speakup/fakekey.c
+++ b/drivers/staging/speakup/fakekey.c
@@ -78,7 +78,7 @@ void speakup_fake_down_arrow(void)
 	/* don't change CPU */
 	preempt_disable();
 
-	__this_cpu_write(reporting_keystroke), true);
+	__this_cpu_write(reporting_keystroke, true);
 	input_report_key(virt_keyboard, KEY_DOWN, PRESSED);
 	input_report_key(virt_keyboard, KEY_DOWN, RELEASED);
 	__this_cpu_write(reporting_keystroke, false);
-- 
1.7.2.2

