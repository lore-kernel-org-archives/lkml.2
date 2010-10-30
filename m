Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0J3Lsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 07:48:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33375 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0J3Ls3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 07:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=U7yGcwNDo0QFMS2AyELHyz/6Or2rFl2mNS4tSTaCoiJme7sGw2Qkfads77ITj1fiFz
         Z+SRUMaUjFAAWMkQJ7MlGymxBOCEB9o8nIaOHbSUOzVqJlhAoc1p67QiqKzRFBFTiI8u
         Jf6V9T2hpG44fUvw3MqzybrD+q3nO+pg1KtYQ=
MIME-Version: 1.0
Date: Sat, 30 Oct 2010 13:48:28 +0200
Message-ID: <AANLkTik41vfVn6K0UDYfoCK7O8j2UHsqhGNdbVckt-PA@mail.gmail.com>
Subject: A couple of Kconfig warnings
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just pulled Linus' tree.

warning: (BT_HIDP && NET && BT && BT_L2CAP && INPUT || USB_HID &&
HID_SUPPORT && USB && INPUT) selects HID which has unmet direct
dependencies (HID_SUPPORT && INPUT)

warning: (SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA
&& I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP
&& EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 &&
I2C && ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C &&
(ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT &&
I2C && PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C &&
ARCH_ACORN || SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 &&
MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C &&
VIDEO_V4L2 && INPUT && VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C &&
INPUT && VIDEO_IR || VIDEO_CX23885 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI &&
I2C && INPUT && IR_CORE || VIDEO_AU0828 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
|| VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
&& PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C &&
EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_SAA7164 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C ||
DVB_PLUTO2 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI
&& I2C || DRM && HAS_IOMEM && (AGP || AGP=n) && !EMULATED_CMPXCHG &&
MMU || FB_DDC && HAS_IOMEM && FB || FB_VIA && HAS_IOMEM && FB && PCI
&& X86 || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD &&
DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL && VIDEO_IR)
selects I2C_ALGOBIT which has unmet direct dependencies (I2C &&
I2C_HELPER_AUTO)
