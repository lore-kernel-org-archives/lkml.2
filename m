Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab0LHBDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:47 -0500
Received: from kroah.org ([198.145.64.141]:33772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab0LHBDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:40 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005746.078860004@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bernie Thompson <bernie@plugable.com>
Subject: [247/289] Staging: udlfb: fix up some sysfs attribute permissions
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit cc9ca9dfddda46b1802d325891a69d7efdbe1f1e and
cc9ca9dfddda46b1802d325891a69d7efdbe1f1e upstream merged together.

They should not be writable by any user

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/udlfb/udlfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -1143,7 +1143,7 @@ static struct device_attribute fb_device
 	__ATTR_RO(metrics_bytes_sent),
 	__ATTR_RO(metrics_cpu_kcycles_used),
 	__ATTR_RO(metrics_misc),
-	__ATTR(metrics_reset, S_IWUGO, NULL, metrics_reset_store),
+	__ATTR(metrics_reset, S_IWUSR, NULL, metrics_reset_store),
 	__ATTR_RW(use_defio),
 };
 


