Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0CaAAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:00:02 -0400
Received: from kroah.org ([198.145.64.141]:45460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab0C3XSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:53 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:04 2010
Message-Id: <20100330225703.854036388@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dean Nelson <dnelson@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [096/116] hwmon: (coretemp) Add missing newline to dev_warn() message
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit 4d7a5644e4adfafe76c2bd8ee168e3f3b5dae3a8 upstream.

Add missing newline to dev_warn() message string. This is more of an issue
with older kernels that don't automatically add a newline if it was missing
from the end of the previous line.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -228,7 +228,7 @@ static int __devinit adjust_tjmax(struct
 		if (err) {
 			dev_warn(dev,
 				 "Unable to access MSR 0xEE, for Tjmax, left"
-				 " at default");
+				 " at default\n");
 		} else if (eax & 0x40000000) {
 			tjmax = tjmax_ee;
 		}


