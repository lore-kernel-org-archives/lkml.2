Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1EKUdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:33:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:60633 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab1EKUdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:33:36 -0400
Date: Wed, 11 May 2011 13:31:51 -0700
From: Greg KH <gregkh@suse.de>
To: "Kilau, Scott" <Scott.Kilau@digi.com>
Cc: "'mreed10@us.ibm.com'" <mreed10@us.ibm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Message-ID: <20110511203151.GA28160@suse.de>
References: <A961E3870077E34C8FEF355D71BFDEAAC77C11492C@mtk-sms-exch01.digi.com>
 <A961E3870077E34C8FEF355D71BFDEAAC77C26CE30@mtk-sms-exch01.digi.com>
 <20110511194318.GA26704@suse.de>
 <A961E3870077E34C8FEF355D71BFDEAAC77C26CE4B@mtk-sms-exch01.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE4B@mtk-sms-exch01.digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:27:25PM -0500, Kilau, Scott wrote:
> > From: Greg KH [mailto:gregkh@suse.de] 
> > Sent: Wednesday, May 11, 2011 2:43 PM
> > To: Kilau, Scott
> > Cc: 'mreed10@us.ibm.com'; 'linux-kernel@vger.kernel.org'; 'Alan Cox'
> > Subject: Re: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port Adapter
> 
> > On Wed, May 11, 2011 at 02:28:07PM -0500, Kilau, Scott wrote:
> > > --- linux-2.6.38.6-vanilla/include/linux/pci_ids.h	2011-04-21 16:34:46.000000000 -0500
> > > +++ linux-2.6.38.6/include/linux/pci_ids.h	2011-04-27 14:56:30.000000000 -0500
> > > @@ -1476,6 +1476,7 @@
> > >  #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
> > >  #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
> > >  #define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
> > > +#define PCIE_DEVICE_ID_NEO_2_OX_IBM     0x00F6
> 
> > Please see the top of this file for why you shouldn't be adding new
> > device ids into it.
> > Third time's a charm?
> > thanks,
> > greg k-h
> 
> Sorry about that.
> Should I just be putting them into 8250_pci.c directly instead?

Yes.

> I was conflicted as to where to put it, as I saw this comment in
> 8250_pci.c, before a list of device ids:
> /* This should be in linux/pci_ids.h */

That comment should be removed :)

thanks,

greg k-h
