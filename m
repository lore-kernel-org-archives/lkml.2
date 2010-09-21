Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0IUWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:18:37 -0400
Received: from core.signal11.us ([64.251.29.136]:47868 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab0IUWSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:18:35 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 1/1] trivial: usbhid: Formatting fix
Date: Tue, 21 Sep 2010 18:18:32 -0400
Message-Id: <1285107512-6940-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C98F245.2000002@ru.mvista.com>
References: <4C98F245.2000002@ru.mvista.com>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 21 18:18:34 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c992f3a12031788331892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added blank line after declarations.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/usbhid/hid-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b729c02..ff90069 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -810,6 +810,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	if (usbhid->urbout) {
 		int actual_length;
 		int skipped_report_id = 0;
+
 		if (buf[0] == 0x0) {
 			/* Don't send the Report ID */
 			buf++;
-- 
1.7.0.4


