Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1EZBY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:24:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31875 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab1EZBY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:24:57 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Alexander Stein'" <alexander.stein@systec-electronic.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>,
        "'Fan, Yongning'" <yongning.fan@intel.com>
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105251409.47309.alexander.stein@systec-electronic.com>
Subject: RE: pch_gpio: Support new device ML7223
Date: Thu, 26 May 2011 10:24:55 +0900
Message-ID: <F873CB63EEA24284982A8FA0F0B0F167@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: Acwa1KWQ8HqXg8uoQ/qPIGVFrpsyywAbS3tw
In-Reply-To: <201105251409.47309.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alexander Stein [mailto:alexander.stein@systec-electronic.com] 
> Sent: Wednesday, May 25, 2011 9:10 PM 

> > #define pch_gpio_resume NULL  #endif
> > 
> > +#define PCI_VENDOR_ID_ROHM             0x10DB
> 
> Should this be moved to pci_ids.h?
OK.
I will move this to pci_ids.h.

> 
> >  static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
> 
> Likewise for the product ID. While at it, the ID for EG20T 
> could also be moved in a separate patch.

We have already upstreamed not only GPIO but also many device drivers(GBE, USBDEV,DMA,UART,SPI,I2C,CAN).
Do you mean we must move these device definitions to pci_ids.h?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

