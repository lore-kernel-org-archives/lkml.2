Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2BAJxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:53:00 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9747 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755308Ab2BAJw6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:52:58 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432N98dKzz1202hzz8275dhz2dhc1bhc31hc1ah2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Topic: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Index: AQHM1rbj1rZDtR84OEuq1/Qi58+pfJYUOhiAgAAF/YCAAAVzgIABiygAgBILLnA=
Date: Wed, 1 Feb 2012 09:37:52 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D043BD1@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
	<201201191646.13798.laurent.pinchart@ideasonboard.com>
	<20120119160739.GB2205@amd.com>
	<201201191727.10176.laurent.pinchart@ideasonboard.com>
 <20120120160128.GF2205@amd.com>
In-Reply-To: <20120120160128.GF2205@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> Sent: Friday, January 20, 2012 9:31 PM
> To: Laurent Pinchart
> Cc: Ohad Ben-Cohen; Tony Lindgren; linux-kernel@vger.kernel.org;
> iommu@lists.linux-foundation.org; Wood Scott-B07421; David Brown; David
> Woodhouse
> Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY
> attribute
> 
> On Thu, Jan 19, 2012 at 05:27:09PM +0100, Laurent Pinchart wrote:
> > > Well, u64 is a catch-all datatype which should suit all drivers. Is
> > > this a problem at ARM?
> >
> > No, it's not a problem for ARM, at least to my knowledge. It just
> > struck me as weird, as we have specific data types for other kinds of
> > addresses (such as dma_addr_t).
> 
> Okay, I looked at the definition and dma_addr_t seems like a good fit.
> To be consistent we should change the iova type of the map/unmap
> functions to dma_addr_t too.
This change is certainly required in the iommu API map/unmap calls.

-Varun

