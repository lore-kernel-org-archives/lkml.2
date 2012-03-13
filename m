Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab2CMAvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:51:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48082 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab2CMAXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Patrick Boettcher <pboettcher@kernellabs.com>,
        Steffen Barszus <steffenbpunkt@googlemail.com>,
        Boris Cuber <me@boris64.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 101/196] FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
Date: Mon, 12 Mar 2012 20:20:14 -0400
Message-Id: <1331598109-31424-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Boettcher <pboettcher@kernellabs.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b934c20de1398d4a82d2ecfeb588a214a910f13f upstream.

This patch fixes the warning about bad names for sys-fs and other kernel-things. The flexcop-pci driver was using '/'-characters in it, which is not good.
This has been fixed in several attempts by several people, but obviously never made it into the kernel.

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: Boris Cuber <me@boris64.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/dvb/b2c2/flexcop-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..4f3e3ce 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(debug,
 	DEBSTATUS);
 
 #define DRIVER_VERSION "0.1"
-#define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define DRIVER_NAME "flexcop-pci"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {
-- 
1.7.9.3

