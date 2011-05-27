Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1E0G61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:58:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1E0G60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:58:26 -0400
Date: Fri, 27 May 2011 00:58:24 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com,
        "'Fan, Yongning'" <yongning.fan@intel.com>
Subject: Re: pch_gpio: Support new device ML7223
Message-ID: <20110527065824.GD31271@ponder.secretlab.ca>
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <201105251409.47309.alexander.stein@systec-electronic.com>
 <F873CB63EEA24284982A8FA0F0B0F167@hacdom.okisemi.com>
 <201105260809.19425.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105260809.19425.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:09:15AM +0200, Alexander Stein wrote:
> On Thursday 26 May 2011 03:24:55 Tomoya MORINAGA wrote:
> > > From: Alexander Stein [mailto:alexander.stein@systec-electronic.com]
> > > Sent: Wednesday, May 25, 2011 9:10 PM
> > > 
> > > > #define pch_gpio_resume NULL  #endif
> > > > 
> > > > +#define PCI_VENDOR_ID_ROHM             0x10DB
> > > 
> > > Should this be moved to pci_ids.h?
> > 
> > OK.
> > I will move this to pci_ids.h.
> > 
> > > >  static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
> > > >  
> > > >  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
> > > > 
> > > > +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
> > > 
> > > Likewise for the product ID. While at it, the ID for EG20T
> > > could also be moved in a separate patch.
> > 
> > We have already upstreamed not only GPIO but also many device drivers(GBE,
> > USBDEV,DMA,UART,SPI,I2C,CAN). Do you mean we must move these device
> > definitions to pci_ids.h?
> 
> I just meant to move 0x8803 from the line above into pci_ids.h. It is 
> unrelated to your patch.
> And if this _must_ be moved to pci_ids.h I'm the wrong person to decide.

The top comment block in pci_ids.h says: "Do not add new entries to
this file unless the definitions are shared between multiple drivers"

g.

