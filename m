Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1GKSug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:50:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58566 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1GKSuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:50:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/4] gma500: Fix dependencies
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Jul 2011 19:41:24 +0100
Message-ID: <20110711184119.8996.2656.stgit@localhost.localdomain>
In-Reply-To: <20110711183933.8996.37507.stgit@localhost.localdomain>
References: <20110711183933.8996.37507.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

ACPI Video is used by GMA500 so we need to depend upon it

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/Kconfig b/drivers/staging/gma500/Kconfig
index bfe2166..6f19fb7 100644
--- a/drivers/staging/gma500/Kconfig
+++ b/drivers/staging/gma500/Kconfig
@@ -1,6 +1,6 @@
 config DRM_PSB
 	tristate "Intel GMA5/600 KMS Framebuffer"
-	depends on DRM && PCI && X86
+	depends on DRM && PCI && X86 && ACPI_VIDEO
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
         select FB_CFB_IMAGEBLIT

