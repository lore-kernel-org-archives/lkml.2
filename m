Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1BRIC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:02:58 -0500
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:52144 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519Ab1BRIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:01:54 -0500
X-Greylist: delayed 1057 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 03:01:54 EST
Message-ID: <4D5E2302.4010204@gmail.com>
Date: Fri, 18 Feb 2011 08:42:58 +0100
From: =?ISO-8859-15?Q?Ren=E9_Herman?= <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CONFIG_BACKLIGHT_CLASS_DEVICE and unmet direct dependencies
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1PqL0d-0006or-0l
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=1.195, vereist 5, ALL_TRUSTED -1.00, BAYES_00 -1.90,
	FREEMAIL_FROM 0.50, PROLO_TRUST_RDNS -3.00, RDNS_DYNAMIC 0.98,
	SPF_NEUTRAL 0.78, TO_NO_BRKTS_DIRECT 3.48, TO_NO_BRKTS_DYNIP 1.33,
	T_TO_NO_BRKTS_FREEMAIL 0.01, UPPERCASE_50_75 0.01)
X-ZiggoSMTP-MailScanner-SpamScore: s
X-ZiggoSMTP-MailScanner-From: rene.herman@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

*config is barfing:

===
warning: (STUB_POULSBO && HAS_IOMEM && PCI && ACPI || FB_BACKLIGHT && 
HAS_IOMEM && FB || DRM_I915 && <choice> && AGP_INTEL && ACPI || 
PANEL_SHARP_LS037V7DW01 && HAS_IOMEM && OMAP2_DSS || PANEL_ACX565AKM && 
HAS_IOMEM && OMAP2_DSS && OMAP2_DSS_SDI && SPI || USB_APPLEDISPLAY && 
USB_SUPPORT && USB || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI 
&& !ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || SONY_LAPTOP && X86 && 
X86_PLATFORM_DEVICES && ACPI && INPUT && RFKILL || THINKPAD_ACPI && X86 
&& X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) || 
EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT && 
EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || ACPI_ASUS && X86 
&& X86_PLATFORM_DEVICES && ACPI || ACPI_CMPC && X86_PLATFORM_DEVICES && 
X86 && ACPI && (RFKILL || RFKILL=n)) selects BACKLIGHT_CLASS_DEVICE 
which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
===

at me -- twice per invocation. Is this a local config problem or should 
some of these selections be adjusted?

Rene.


