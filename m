Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2LCRgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:36:22 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:6755
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697Ab2LCRgV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:36:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI98dI9371I179dN542I1432Izz1de0h1202h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1155h)
Date: Mon, 3 Dec 2012 11:36:12 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Joerg Roedel <joro@8bytes.org>
CC: Sethi Varun-B16395 <B16395@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tabi Timur-B04825 <B04825@freescale.com>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
	<1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
	<20121202140323.GO30633@8bytes.org>
	<C5ECD7A89D1DC44195F34B25E172658D2B2A51@039-SN2MPN1-013.039d.mgd.msft.net>
	<20121203172712.GA18368@8bytes.org>
In-Reply-To: <20121203172712.GA18368@8bytes.org> (from joro@8bytes.org on
	Mon Dec  3 11:27:12 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1354556172.2960.12@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 11:27:12 AM, Joerg Roedel wrote:
> On Mon, Dec 03, 2012 at 04:57:29PM +0000, Sethi Varun-B16395 wrote:
> >
> >
> > > -----Original Message-----
> > > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > > bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> > > Sent: Sunday, December 02, 2012 7:33 PM
> > > To: Sethi Varun-B16395
> > > Cc: linux-kernel@vger.kernel.org;  
> iommu@lists.linux-foundation.org; Wood
> > > Scott-B07421; linuxppc-dev@lists.ozlabs.org; Tabi Timur-B04825
> > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > > required by fsl PAMU driver.
> > >
> > > Hmm, we need to work out a good abstraction for this.
> > >
> > > On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> > > > Added the following domain attributes required by FSL PAMU  
> driver:
> > > > 1. Subwindows field added to the iommu domain geometry  
> attribute.
> > >
> > > Are the Subwindows mapped with full size or do you map only parts  
> of the
> > > subwindows?
> > >
> > [Sethi Varun-B16395] It's possible to map a part of the subwindow  
> i.e.
> > size of the mapping can be less than the sub window size.
> 
> Yes, I know that this is possible. But do you plan to support that or  
> is
> it sufficient when the whole subwindow is mapped?

We do plan to support that.

-Scott
