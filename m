Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0KILRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:17:22 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:43603 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753034Ab0KILRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:17:19 -0500
Subject: unmet dependencies
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 08:17:08 -0300
Message-ID: <1289301428.2260.1.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Todays randconfig on Linus' latest tree is producing:

warning: (HAVE_TEXT_POKE_SMP && SMP) selects STOP_MACHINE which has
unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU)
warning: (MTD_NAND && MTD || MTD_DOC2000 && MTD || MTD_DOC2001 && MTD ||
MTD_DOC2001PLUS && MTD) selects MTD_NAND_IDS which has unmet direct
dependencies (MTD && MTD_NAND)
warning: (IMA && SECURITY && !S390) selects TCG_TPM which has unmet
direct dependencies (HAS_IOMEM && EXPERIMENTAL)
warning: (SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA &&
I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP &&
EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 && I2C &&
ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C &&
(ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT && I2C
&& PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C && ARCH_ACORN
|| SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT
&& VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS &&
VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR ||
VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 &&
DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_AU0828
&& MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE &&
USB && VIDEO_V4L2 || VIDEO_IVTV && MEDIA_SUPPORT &&
VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR
|| VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 &&
DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR ||
VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 &&
DVB_CORE && PCI && I2C || DVB_PLUTO2 && MEDIA_SUPPORT &&
DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C || DRM && HAS_IOMEM &&
(AGP || AGP=n) && !EMULATED_CMPXCHG && MMU || FB_DDC && HAS_IOMEM && FB
|| FB_VIA && HAS_IOMEM && FB && PCI && X86 || VIDEO_CX25821 && STAGING
&& !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C &&
INPUT && BKL && VIDEO_IR) selects I2C_ALGOBIT which has unmet direct
dependencies (I2C && I2C_HELPER_AUTO)
warning: (I2C_PCA_PLATFORM && I2C || I2C_PCA_ISA && I2C && ISA) selects
I2C_ALGOPCA which has unmet direct dependencies (I2C && I2C_HELPER_AUTO)
warning: (GPIO_VX855 && GPIOLIB) selects MFD_VX855 which has unmet
direct dependencies (MFD_SUPPORT && PCI)
warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO
&& EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL which
has unmet direct dependencies (CRYPTO && EXPERIMENTAL)

Thanks,
Davidlohr

