Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0KGH6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 02:58:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50773 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0KGH6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 02:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=q3ulKRBkCY6XjvGpUyN84VcGrPMPAtilTgfI22ZRu3KEbp2nJifz27CWqhBxIszyWr
         1cXfUQhCiruXMKs6vaS4p37wz2bu/OetPZl5U/iSyG7sesx5yroJB11ZfZ92bOe1St1G
         ztvKXQRFjn8Zx3HknaZceo2tz1s02QdQnNP5E=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Lots of nasty kconfig warnings with 2.6.37-rc1
Date: Sun, 7 Nov 2010 08:57:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101101155305.GB17893@elliptictech.com>
In-Reply-To: <20101101155305.GB17893@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011070857.54479.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 1 listopada 2010 o 16:53:05 Nick Bowler wrote:
> With 2.6.37-rc1, I'm getting some pretty nasty warnings in my build...
> 
>   % make silentoldconfig
>   make -C /scratch_space/linux-2.6 O=/scratch_space/linux-emergent/.
> silentoldconfig GEN     /scratch_space/linux-emergent/Makefile
>   scripts/kconfig/conf --silentoldconfig Kconfig
>   warning: (FB_BACKLIGHT && HAS_IOMEM && FB || DRM_I915 && <choice> &&
> AGP_INTEL && ACPI || PANEL_SHARP_LS037V7DW01 && HAS_IOMEM && OMAP2_DSS ||
> PANEL_ACX565AKM && HAS_IOMEM && OMAP2_DSS && OMAP2_DSS_SDI && SPI ||
> USB_APPLEDISPLAY && USB_SUPPORT && USB || ASUS_LAPTOP && X86 &&
> X86_PLATFORM_DEVICES && ACPI && !ACPI_ASUS && INPUT && (RFKILL ||
> RFKILL=n) || SONY_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT
> && RFKILL || THINKPAD_ACPI && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT
> && (RFKILL || RFKILL=n) || EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES &&
> ACPI && INPUT && EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI ||
> ACPI_ASUS && X86 && X86_PLATFORM_DEVICES && ACPI || ACPI_CMPC &&
> X86_PLATFORM_DEVICES && X86 && ACPI && (RFKILL || RFKILL=n)) selects
> BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM &&
> BACKLIGHT_LCD_SUPPORT) warning: (MAC80211_LEDS && NET && WIRELESS &&
> MAC80211 || ADB_PMU_LED_IDE && MACINTOSH_DRIVERS && ADB_PMU_LED ||
> INPUT_WINBOND_CIR && !S390 && INPUT && INPUT_MISC && X86 && PNP ||
> LEDS_COBALT_RAQ && NEW_LEDS && LEDS_CLASS=y && MIPS_COBALT || LEDS_SUNFIRE
> && NEW_LEDS && LEDS_CLASS && SPARC64) selects LEDS_TRIGGERS which has
> unmet direct dependencies (NEW_LEDS && LEDS_CLASS) warning: (AX88796_93CX6
> && NETDEVICES && NET_ETHERNET && AX88796 || RTL8180 && NETDEVICES && WLAN
> && MAC80211 && PCI && EXPERIMENTAL || RTL8187 && NETDEVICES && WLAN &&
> MAC80211 && USB || ADM8211 && NETDEVICES && WLAN && MAC80211 && PCI &&
> EXPERIMENTAL || RT2400PCI && NETDEVICES && WLAN && RT2X00 && PCI ||
> RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT61PCI && NETDEVICES
> && WLAN && RT2X00 && PCI || RT2800PCI && NETDEVICES && WLAN && RT2X00 &&
> (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL || R8187SE && STAGING &&
> !STAGING_EXCLUDE_BUILD && PCI && WLAN) selects EEPROM_93CX6 which has
> unmet direct dependencies (MISC_DEVICES) warning: (FB_BACKLIGHT &&
> HAS_IOMEM && FB || DRM_I915 && <choice> && AGP_INTEL && ACPI ||
> PANEL_SHARP_LS037V7DW01 && HAS_IOMEM && OMAP2_DSS || PANEL_ACX565AKM &&
> HAS_IOMEM && OMAP2_DSS && OMAP2_DSS_SDI && SPI || USB_APPLEDISPLAY &&
> USB_SUPPORT && USB || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI
> && !ACPI_ASUS && INPUT && (RFKILL || RFKILL=n) || SONY_LAPTOP && X86 &&
> X86_PLATFORM_DEVICES && ACPI && INPUT && RFKILL || THINKPAD_ACPI && X86 &&
> X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=n) ||
> EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
> EXPERIMENTAL && (RFKILL || RFKILL=n) && HOTPLUG_PCI || ACPI_ASUS && X86 &&
> X86_PLATFORM_DEVICES && ACPI || ACPI_CMPC && X86_PLATFORM_DEVICES && X86
> && ACPI && (RFKILL || RFKILL=n)) selects BACKLIGHT_CLASS_DEVICE which has
> unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT) warning:
> (MAC80211_LEDS && NET && WIRELESS && MAC80211 || ADB_PMU_LED_IDE &&
> MACINTOSH_DRIVERS && ADB_PMU_LED || INPUT_WINBOND_CIR && !S390 && INPUT &&
> INPUT_MISC && X86 && PNP || LEDS_COBALT_RAQ && NEW_LEDS && LEDS_CLASS=y &&
> MIPS_COBALT || LEDS_SUNFIRE && NEW_LEDS && LEDS_CLASS && SPARC64) selects
> LEDS_TRIGGERS which has unmet direct dependencies (NEW_LEDS && LEDS_CLASS)
> warning: (AX88796_93CX6 && NETDEVICES && NET_ETHERNET && AX88796 ||
> RTL8180 && NETDEVICES && WLAN && MAC80211 && PCI && EXPERIMENTAL ||
> RTL8187 && NETDEVICES && WLAN && MAC80211 && USB || ADM8211 && NETDEVICES
> && WLAN && MAC80211 && PCI && EXPERIMENTAL || RT2400PCI && NETDEVICES &&
> WLAN && RT2X00 && PCI || RT2500PCI && NETDEVICES && WLAN && RT2X00 && PCI
> || RT61PCI && NETDEVICES && WLAN && RT2X00 && PCI || RT2800PCI &&
> NETDEVICES && WLAN && RT2X00 && (RT2800PCI_PCI || RT2800PCI_SOC) &&
> EXPERIMENTAL || R8187SE && STAGING && !STAGING_EXCLUDE_BUILD && PCI &&
> WLAN) selects EEPROM_93CX6 which has unmet direct dependencies
> (MISC_DEVICES)
> 
> .config is attached.

See this:

https://bugzilla.kernel.org/show_bug.cgi?id=22112

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
