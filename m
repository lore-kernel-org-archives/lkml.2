Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2F0T1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:27:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54868 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab2F0T1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:27:08 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, grabner@icg.tugraz.at, stefanha@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 5/9] staging: line6: changed interface of pod_send_channel()
Date: Wed, 27 Jun 2012 21:25:59 +0200
Message-Id: <1340825163-32568-6-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
References: <1340825163-32568-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusted interface of pod_send_channel() in order to take changes of
line6_send_program() into account.

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/pod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 8667aaf..459f325 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -405,7 +405,7 @@ void line6_pod_midi_postprocess(struct usb_line6_pod *pod, unsigned char *data,
 /*
 	Send channel number (i.e., switch to a different sound).
 */
-static void pod_send_channel(struct usb_line6_pod *pod, int value)
+static void pod_send_channel(struct usb_line6_pod *pod, u8 value)
 {
 	line6_invalidate_current(&pod->dumpreq);
 
-- 
1.7.7.6

