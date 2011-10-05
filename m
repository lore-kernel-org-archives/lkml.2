Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1JEEAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:00:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:37373 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1JEEAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:00:13 -0400
Date: Wed, 5 Oct 2011 00:00:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the moduleh tree
Message-ID: <20111005040005.GB14123@windriver.com>
References: <20111004175703.0e319ee270c9dcd1ff253164@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111004175703.0e319ee270c9dcd1ff253164@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: manual merge of the moduleh tree] On 04/10/2011 (Tue 17:57) Stephen Rothwell wrote:

> Hi Paul,
> 
> I also dropped the following already applied patches:
> 
> wireless-ath6kl-use-of-module_param-requires-the-inc.patch
> staging-add-module.h-to-various-iio-drivers.patch

I've dropped these, plus the usb dwc3 patch which I see Greg picked
up. I've also added the five new fixups for the staging and ath6l that
you posted from the previous tree -- only two of them need to be in the
post-merge queue long term (the export.h ones).

Series delta is below.

Thanks,
Paul.

---

diff --git a/series b/series
index eccd196..d99df0f 100644
--- a/series
+++ b/series
@@ -1,7 +1,6 @@
 drivers-md-change-module.h-export.h-in-persistent-da.patch
 block-bsg-lib.c-change-module.h-export.h-in-power-co.patch
 drivers-base-change-module.h-export.h-in-power-commo.patch
-wireless-ath6kl-use-of-module_param-requires-the-inc.patch
 rtlwifi-use-of-module_param-requires-the-inclusion-o.patch
 mmc-using-module_param-requires-the-inclusion-of-mod.patch
 NFC-use-of-module-facilities-requires-the-inclusion-.patch
@@ -14,7 +13,10 @@ drivers-net-Add-module.h-to-wireless-ath-ath6kl-sdio.patch
 drivers-net-wireless-ath-ath5k-debug.c-does-not-need.patch
 drivers-bcma-driver_chipcommon_pmu.c-needs-export.h-.patch
 drivers-base-Add-export.h-to-regmap-regcache.c.patch
-drivers-usb-Add-module.h-to-various-dwc3-drivers.patch
-staging-add-module.h-to-various-iio-drivers.patch
 staging-Add-export.h-to-rts5139-rts51x_scsi.c.patch
 pinctrl-EXPORT_SYMBOL-needs-export.h.patch
+staging-Add-export.h-for-EXPORT_SYMBOL-to-drivers-st.patch
+ath6kl-THIS_MODULES-needs-export.h.patch
+ath6kl-module_param-needs-the-inclusion-of-modulepar.patch
+staging-iio-adc-add-includes-of-module.h-and-stat.h.patch
+staging-r8712u-include-module.h-where-needed.patch
