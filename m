Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1EZGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:09:26 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:46609 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab1EZGJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:09:25 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Subject: Re: pch_gpio: Support new device ML7223
Date: Thu, 26 May 2011 08:09:15 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        "'Fan, Yongning'" <yongning.fan@intel.com>
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105251409.47309.alexander.stein@systec-electronic.com> <F873CB63EEA24284982A8FA0F0B0F167@hacdom.okisemi.com>
In-Reply-To: <F873CB63EEA24284982A8FA0F0B0F167@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105260809.19425.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011 03:24:55 Tomoya MORINAGA wrote:
> > From: Alexander Stein [mailto:alexander.stein@systec-electronic.com]
> > Sent: Wednesday, May 25, 2011 9:10 PM
> > 
> > > #define pch_gpio_resume NULL  #endif
> > > 
> > > +#define PCI_VENDOR_ID_ROHM             0x10DB
> > 
> > Should this be moved to pci_ids.h?
> 
> OK.
> I will move this to pci_ids.h.
> 
> > >  static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
> > >  
> > >  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
> > > 
> > > +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
> > 
> > Likewise for the product ID. While at it, the ID for EG20T
> > could also be moved in a separate patch.
> 
> We have already upstreamed not only GPIO but also many device drivers(GBE,
> USBDEV,DMA,UART,SPI,I2C,CAN). Do you mean we must move these device
> definitions to pci_ids.h?

I just meant to move 0x8803 from the line above into pci_ids.h. It is 
unrelated to your patch.
And if this _must_ be moved to pci_ids.h I'm the wrong person to decide.

Regards,
Alexander
