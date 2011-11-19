Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1KSRyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:54:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53480 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1KSRyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:54:22 -0500
MIME-Version: 1.0
In-Reply-To: <1321693664-3709-1-git-send-email-lars.schmohl@gmail.com>
References: <1321693664-3709-1-git-send-email-lars.schmohl@gmail.com>
Date: Sat, 19 Nov 2011 18:54:21 +0100
Message-ID: <CAOui-B41NjqGQVYhF3nk-WUwmH_6AsTD8F5bqZTVUtzWJv8nEw@mail.gmail.com>
Subject: [PATCH] ASIX: Add Asus ASIX USB ID
From: Lars Schmohl <lars.schmohl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Schmohl <lars.schmohl@gmail.com>

This device is bundled together with the Asus UX21E/UX31E laptops

Signed-off-by: Lars Schmohl <lars.schmohl@gmail.com>
---
 drivers/net/usb/asix.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index e81e22e..6947168 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1619,6 +1619,10 @@ static const struct usb_device_id        products [] = {
       // ASIX 88772a
       USB_DEVICE(0x0db0, 0xa877),
       .driver_info = (unsigned long) &ax88772_info,
+}, {
+       /* ASUS ASIX */
+       USB_DEVICE(0x0b95, 0x7e2b),
+       .driver_info = (unsigned long) &ax88772_info,
 },
       { },            // END
 };
--
1.7.4.1
