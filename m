Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422895Ab2JDQbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:31:18 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:20248
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422881Ab2JDQbP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:31:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [RFC][PATCH 1/3] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Topic: [RFC][PATCH 1/3] iommu/fsl: Store iommu domain information
 pointer in archdata.
Thread-Index: AQHNlmmGjuy/oEmfUUWHdr5lVrmL+peSAmEAgBdrSeA=
Date: Thu, 4 Oct 2012 16:30:58 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D1EFD59@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com>
 <1348060632-12997-2-git-send-email-b16395@freescale.com>
 <5BDB4D18-CB0D-4EBA-B38F-A278B7C00A61@kernel.crashing.org>
In-Reply-To: <5BDB4D18-CB0D-4EBA-B38F-A278B7C00A61@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Wednesday, September 19, 2012 7:20 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; joerg.roedel@amd.com; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Sethi Varun-B16395
> Subject: Re: [RFC][PATCH 1/3] iommu/fsl: Store iommu domain information
> pointer in archdata.
> 
> 
> On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com>
> <b16395@freescale.com> wrote:
> 
> > From: Varun Sethi <Varun.Sethi@freescale.com>
> >
> > Add a new field in the device (powerpc) archdata structure for storing
> > iommu domain information pointer. This pointer is stored when the
> > device is attached to a particular domain.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > arch/powerpc/include/asm/device.h |    4 ++++
> > 1 files changed, 4 insertions(+), 0 deletions(-)
> 
> Not too familiar, but what does the IBM Server IOMMU do for iommu_domain?
>
[Sethi Varun-B16395] I am not sure if the IBM iommu driver implements the iommu
API.

-Varun
 



