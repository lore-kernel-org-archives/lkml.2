Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2EIGKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:10:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39028 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531Ab2EIFxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:33 -0400
Message-Id: <20120509055048.669105359@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [ 138/167] [PATCH] nouveau: initialise has_optimus variable.
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit addde4ec31456c5f1e9b61aae3edcfeb0f338f87 upstream.

We should initialise this to 0 really to avoid getting false positives.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 7814a76..284bd25 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -270,7 +270,7 @@ static bool nouveau_dsm_detect(void)
 	struct acpi_buffer buffer = {sizeof(acpi_method_name), acpi_method_name};
 	struct pci_dev *pdev = NULL;
 	int has_dsm = 0;
-	int has_optimus;
+	int has_optimus = 0;
 	int vga_count = 0;
 	bool guid_valid;
 	int retval;
-- 
1.7.10



