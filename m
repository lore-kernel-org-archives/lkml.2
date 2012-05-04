Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2EDVHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:07:40 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab2EDUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:12 -0400
Message-Id: <20120504204229.667233014@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>
Subject: [ 62/75] nouveau: initialise has_optimus variable.
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit addde4ec31456c5f1e9b61aae3edcfeb0f338f87 upstream.

We should initialise this to 0 really to avoid getting false positives.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


