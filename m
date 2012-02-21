Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2BUVVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:21:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52622 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754607Ab2BUVVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:21:36 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+AKMcP1d6A+E0bi+5V+R5HLJhOO0M9Fs8szvNUa8
	52/sfXm5Si8xLh
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: netdev@vger.kernel.org, netfilter@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Kconfig: unmet direct dependencies in 3.3-rc4
Date: Tue, 21 Feb 2012 22:21:26 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.7; KDE/4.8.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202212221.27202.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

running a few "make randconfigs" gave warnings (seen below) for the current 
git kernel tree. Are there already patches in -next for all ?


warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct 
dependencies (SMP && MODULE_UNLOAD || 
HOTPLUG_CPU)


warning: (DRM_RADEON_KMS && DRM_I915 && STUB_POULSBO && FB_BACKLIGHT && 
USB_APPLEDISPLAY && FB_OLPC_DCON && 
ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_ASUS && 
ACPI_CMPC && SAMSUNG_Q10) selects 
BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && 
BACKLIGHT_LCD_SUPPORT)


warning: (WIMAX_IWMC3200_SDIO) selects IWMC3200TOP which has unmet direct 
dependencies (MMC && EXPERIMENTAL)


warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct 
dependencies (NET && INET && NETFILTER)



-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
