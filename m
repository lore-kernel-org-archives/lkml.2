Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1B1Qn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:43:26 -0500
Received: from kroah.org ([198.145.64.141]:48174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1B1Qh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:10 2011
Message-Id: <20110228162410.629428506@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [49/68] platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 8a6a142c1286797978e4db266d22875a5f424897 upstream.

Don't allow everybody to change WMI settings.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/tc1100-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/tc1100-wmi.c
+++ b/drivers/platform/x86/tc1100-wmi.c
@@ -177,7 +177,7 @@ set_bool_##value(struct device *dev, str
 			return -EINVAL; \
 	return count; \
 } \
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO | S_IWUSR, \
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, \
 	show_bool_##value, set_bool_##value);
 
 show_set_bool(wireless, TC1100_INSTANCE_WIRELESS);


