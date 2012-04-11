Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab2DKXQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44096 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab2DKXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:48 -0400
Message-Id: <20120411231027.702626463@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Alf=20H=C3=B8gemark?= <alf@i100.no>,
        Chris Ball <cjb@laptop.org>
Subject: [ 55/78] mmc: sdhci-dove: Fix compile error by including module.h
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alf Høgemark <alf@i100.no>

commit 8c2fc8e413ecc2c96b696e28d4eb1bc6cee8dc84 upstream.

This patch fixes a compile error in drivers/mmc/host/sdhci-dove.c
by including the linux/module.h file.

Signed-off-by: Alf Høgemark <alf@i100.no>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-dove.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/module.h>
 #include <linux/mmc/host.h>
 
 #include "sdhci-pltfm.h"


