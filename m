Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0ELPoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:44:30 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:51416 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab0ELPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:44:27 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net A59B9107E0A
Subject: [PATCH 3/5] HID: Correctly mark init and exit functions of Roccat
 Kone module
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:44:25 +0200
Message-ID: <1273679065.2927.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bbc9f26b13e7756061adb62c561d40f060623bd7 Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Sat, 8 May 2010 17:20:38 +0200
Subject: [PATCH 3/5] HID: Correctly mark init and exit functions of
Roccat Kone module

Added the __init and __exit hints for module functions.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c
b/drivers/hid/hid-roccat-kone.c
index 9d68442..0b1db24 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -990,12 +990,12 @@ static struct hid_driver kone_driver = {
 		.raw_event = kone_raw_event
 };
 
-static int kone_init(void)
+static int __init kone_init(void)
 {
 	return hid_register_driver(&kone_driver);
 }
 
-static void kone_exit(void)
+static void __exit kone_exit(void)
 {
 	hid_unregister_driver(&kone_driver);
 }
-- 
1.6.6.1



