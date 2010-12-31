Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0LaA4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:56:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54008 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0LaA4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:56:15 -0500
Date: Fri, 31 Dec 2010 11:56:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jassi Brar <jassi.brar@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the sound-asoc tree with the s5p tree
Message-Id: <20101231115609.53355fc7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/plat-samsung/include/plat/devs.h between commit
1b6e8eda6f0e7cd4f28e522a5e77e76f6985af9d ("Merge branch 'next-s5pv310'
into for-next") from the s5p tree and commit
83e37b8e400ca51cc97946815b3055daacd92fa8 ("ARM: Samsung: Define common
audio-dma device") from the sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-samsung/include/plat/devs.h
index 7aba430,e9e3b6e..0000000
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@@ -49,59 -53,44 +49,58 @@@ extern struct platform_device s3c_devic
  extern struct platform_device s3c_device_i2c5;
  extern struct platform_device s3c_device_i2c6;
  extern struct platform_device s3c_device_i2c7;
 +extern struct platform_device s3c_device_iis;
 +extern struct platform_device s3c_device_lcd;
 +extern struct platform_device s3c_device_nand;
 +extern struct platform_device s3c_device_ohci;
 +extern struct platform_device s3c_device_onenand;
- extern struct platform_device s3c_device_pcm;
  extern struct platform_device s3c_device_rtc;
 -extern struct platform_device s3c_device_adc;
  extern struct platform_device s3c_device_sdi;
 -extern struct platform_device s3c_device_iis;
 -extern struct platform_device s3c_device_hwmon;
 -extern struct platform_device s3c_device_hsmmc0;
 -extern struct platform_device s3c_device_hsmmc1;
 -extern struct platform_device s3c_device_hsmmc2;
 -extern struct platform_device s3c_device_hsmmc3;
 -extern struct platform_device s3c_device_cfcon;
 -
  extern struct platform_device s3c_device_spi0;
  extern struct platform_device s3c_device_spi1;
 +extern struct platform_device s3c_device_ts;
 +extern struct platform_device s3c_device_timer[];
 +extern struct platform_device s3c_device_usbgadget;
 +extern struct platform_device s3c_device_usb_hsotg;
 +extern struct platform_device s3c_device_wdt;
  
 -extern struct platform_device s5pc100_device_spi0;
 -extern struct platform_device s5pc100_device_spi1;
 -extern struct platform_device s5pc100_device_spi2;
 -extern struct platform_device s5pv210_device_spi0;
 -extern struct platform_device s5pv210_device_spi1;
 +extern struct platform_device s5p_device_fimc0;
 +extern struct platform_device s5p_device_fimc1;
 +extern struct platform_device s5p_device_fimc2;
 +extern struct platform_device s5p_device_mipi_csis0;
 +extern struct platform_device s5p_device_mipi_csis1;
 +extern struct platform_device s5p_device_onenand;
 +
 +extern struct platform_device s5p6440_device_iis;
 +extern struct platform_device s5p6440_device_pcm;
  extern struct platform_device s5p6440_device_spi0;
  extern struct platform_device s5p6440_device_spi1;
 -extern struct platform_device s5p6450_device_spi0;
 -extern struct platform_device s5p6450_device_spi1;
  
 -extern struct platform_device s3c_device_hwmon;
 +extern struct platform_device s5p6442_device_iis0;
 +extern struct platform_device s5p6442_device_iis1;
 +extern struct platform_device s5p6442_device_pcm0;
 +extern struct platform_device s5p6442_device_pcm1;
 +extern struct platform_device s5p6442_device_spi;
  
 -extern struct platform_device s3c_device_nand;
 -extern struct platform_device s3c_device_onenand;
 -extern struct platform_device s3c64xx_device_onenand1;
 -extern struct platform_device s5p_device_onenand;
 +extern struct platform_device s5p6450_device_iis0;
 +extern struct platform_device s5p6450_device_iis1;
 +extern struct platform_device s5p6450_device_iis2;
 +extern struct platform_device s5p6450_device_pcm0;
 +extern struct platform_device s5p6450_device_spi0;
 +extern struct platform_device s5p6450_device_spi1;
  
 -extern struct platform_device s3c_device_usbgadget;
 -extern struct platform_device s3c_device_usb_hsotg;
 +extern struct platform_device s5pc100_device_ac97;
 +extern struct platform_device s5pc100_device_iis0;
 +extern struct platform_device s5pc100_device_iis1;
 +extern struct platform_device s5pc100_device_iis2;
 +extern struct platform_device s5pc100_device_pcm0;
 +extern struct platform_device s5pc100_device_pcm1;
 +extern struct platform_device s5pc100_device_spdif;
 +extern struct platform_device s5pc100_device_spi0;
 +extern struct platform_device s5pc100_device_spi1;
 +extern struct platform_device s5pc100_device_spi2;
  
  extern struct platform_device s5pv210_device_ac97;
 -extern struct platform_device s5pv210_device_pcm0;
 -extern struct platform_device s5pv210_device_pcm1;
 -extern struct platform_device s5pv210_device_pcm2;
  extern struct platform_device s5pv210_device_iis0;
  extern struct platform_device s5pv210_device_iis1;
  extern struct platform_device s5pv210_device_iis2;
@@@ -116,13 -100,36 +115,14 @@@ extern struct platform_device s5pv310_d
  extern struct platform_device s5pv310_device_i2s0;
  extern struct platform_device s5pv310_device_i2s1;
  extern struct platform_device s5pv310_device_i2s2;
 +extern struct platform_device s5pv310_device_pcm0;
 +extern struct platform_device s5pv310_device_pcm1;
 +extern struct platform_device s5pv310_device_pcm2;
 +extern struct platform_device s5pv310_device_pd[];
  extern struct platform_device s5pv310_device_spdif;
  
 -extern struct platform_device s5p6442_device_pcm0;
 -extern struct platform_device s5p6442_device_pcm1;
 -extern struct platform_device s5p6442_device_iis0;
 -extern struct platform_device s5p6442_device_iis1;
 -extern struct platform_device s5p6442_device_spi;
 -
 -extern struct platform_device s5p6440_device_pcm;
 -extern struct platform_device s5p6440_device_iis;
 -
 -extern struct platform_device s5p6450_device_iis0;
 -extern struct platform_device s5p6450_device_pcm0;
 -
 -extern struct platform_device s5pc100_device_ac97;
 -extern struct platform_device s5pc100_device_pcm0;
 -extern struct platform_device s5pc100_device_pcm1;
 -extern struct platform_device s5pc100_device_iis0;
 -extern struct platform_device s5pc100_device_iis1;
 -extern struct platform_device s5pc100_device_iis2;
 -extern struct platform_device s5pc100_device_spdif;
 -
  extern struct platform_device samsung_device_keypad;
 -
 -extern struct platform_device s5p_device_fimc0;
 -extern struct platform_device s5p_device_fimc1;
 -extern struct platform_device s5p_device_fimc2;
++extern struct platform_device samsung_asoc_dma;
  
  /* s3c2440 specific devices */
  
