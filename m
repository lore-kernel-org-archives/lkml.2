Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2LKEue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:50:34 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19575 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab2LKEud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:50:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(zzbb2dI98dI9371I179dN542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: RE: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Topic: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Index: AQHN1zryreXJamSE4kOq4mmamJ54mJgS/5Rw
Date: Tue, 11 Dec 2012 04:50:29 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D2C4AEE@039-SN2MPN1-013.039d.mgd.msft.net>
References: <C5ECD7A89D1DC44195F34B25E172658D2B70EE@039-SN2MPN1-013.039d.mgd.msft.net>
	<1354645371.16710.15@snotra>
	<C5ECD7A89D1DC44195F34B25E172658D2C09A4@039-SN2MPN1-013.039d.mgd.msft.net>
 <1355187644.5334.23@snotra>
In-Reply-To: <1355187644.5334.23@snotra>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.77]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, December 11, 2012 6:31 AM
> To: Sethi Varun-B16395
> Cc: Wood Scott-B07421; Joerg Roedel; linux-kernel@vger.kernel.org;
> iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org; Tabi
> Timur-B04825
> Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> required by fsl PAMU driver.
> 
> On 12/10/2012 04:10:06 AM, Sethi Varun-B16395 wrote:
> >
> >
> > > -----Original Message-----
> > > From: Wood Scott-B07421
> > > Sent: Tuesday, December 04, 2012 11:53 PM
> > > To: Sethi Varun-B16395
> > > Cc: Wood Scott-B07421; Joerg Roedel; linux-kernel@vger.kernel.org;
> > > iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;
> > Tabi
> > > Timur-B04825
> > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > > required by fsl PAMU driver.
> > >
> > > On 12/04/2012 05:53:33 AM, Sethi Varun-B16395 wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Wood Scott-B07421
> > > > > Sent: Monday, December 03, 2012 10:34 PM
> > > > > To: Sethi Varun-B16395
> > > > > Cc: Joerg Roedel; linux-kernel@vger.kernel.org;
> > iommu@lists.linux-
> > > > > foundation.org; Wood Scott-B07421;
> > linuxppc-dev@lists.ozlabs.org;
> > > > Tabi
> > > > > Timur-B04825
> > > > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain
> > attributes
> > > > > required by fsl PAMU driver.
> > > > >
> > > > > On 12/03/2012 10:57:29 AM, Sethi Varun-B16395 wrote:
> > > > > >
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: iommu-bounces@lists.linux-foundation.org
> > [mailto:iommu-
> > > > > > > bounces@lists.linux-foundation.org] On Behalf Of Joerg
> > Roedel
> > > > > > > Sent: Sunday, December 02, 2012 7:33 PM
> > > > > > > To: Sethi Varun-B16395
> > > > > > > Cc: linux-kernel@vger.kernel.org;
> > > > iommu@lists.linux-foundation.org;
> > > > > > Wood
> > > > > > > Scott-B07421; linuxppc-dev@lists.ozlabs.org; Tabi
> > Timur-B04825
> > > > > > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain
> > > > attributes
> > > > > > > required by fsl PAMU driver.
> > > > > > >
> > > > > > > Hmm, we need to work out a good abstraction for this.
> > > > > > >
> > > > > > > On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> > > > > > > > Added the following domain attributes required by FSL PAMU
> > > > driver:
> > > > > > > > 1. Subwindows field added to the iommu domain geometry
> > > > attribute.
> > > > > > >
> > > > > > > Are the Subwindows mapped with full size or do you map only
> > > > parts
> > > > > > of the
> > > > > > > subwindows?
> > > > > > >
> > > > > > [Sethi Varun-B16395] It's possible to map a part of the
> > subwindow
> > > > i.e.
> > > > > > size of the mapping can be less than the sub window size.
> > > > > >
> > > > > > > > +	 * This attribute indicates number of DMA subwindows
> > > > > supported
> > > > > > by
> > > > > > > > +	 * the geometry. If there is a single window that maps
> > > > the
> > > > > > entire
> > > > > > > > +	 * geometry, attribute must be set to "1". A value of
> > > > "0"
> > > > > > implies
> > > > > > > > +	 * that this mechanism is not used at all(normal paging
> > > > is
> > > > > > used).
> > > > > > > > +	 * Value other than* "0" or "1" indicates the actual
> > > > number
> > > > > of
> > > > > > > > +	 * subwindows.
> > > > > > > > +	 */
> > > > > > >
> > > > > > > This semantic is ugly, how about a feature detection
> > mechanism?
> > > > > > >
> > > > > > [Sethi Varun-B16395] A feature mechanism to query the type of
> > > > IOMMU?
> > > > >
> > > > > A feature mechanism to determine whether this subwindow
> > mechanism is
> > > > > available, and what the limits are.
> > > > >
> > > > So, we use the IOMMU capability interface to find out if IOMMU
> > > > supports sub windows or not, right? But still number of sub
> > windows
> > > > would be specified as a part of the geometry and the valid value
> > for
> > > > sub windows would  0,1 or actual number of sub windows.
> > >
> > > How does a user of the interface find out what values are possible
> > for
> > > the "actual number of subwindows"?  How does a user of the
> > interface find
> > > out whether there are any limitations on specifying a value of zero
> > (in
> > > the case of PAMU, that would be a maximum 1 MiB naturally-aligned
> > > aperture to support arbitrary 4KiB mappings)?
> > How about if we say that the default value for subwindows is zero and
> > this what you get when you read the geometry (iommu_get_attr) after
> > initializing the domain? In that case the user would know that
> > implication of setting subwindows to zero with respect to the aperture
> > size.
> 
> So it would default to the maximum aperture size possible with no
> subwindows?  That might be OK, though is there a way to reset the domain
> later on to get back to that informational state?
> 
[Sethi Varun-B16395] Yes, that can be done via iommu_set_attr API.

> How about finding out the maximum number of subwindows?
[Sethi Varun-B16395] We can introduce an API to determine the permissible range of values for an attribute, but it may be redundant for other IOMMU implementations. For the IOMMU implementations where geometry is just a read only attribute, iommu_get_attr returns the set of permissible values. I think it would be better if we can add a read only field (for the users) "max_subwindows" to the geometry.

-Varun



