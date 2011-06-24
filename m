Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1FXEI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 00:08:57 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31217 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752Ab1FXEIy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 00:08:54 -0400
X-SpamScore: -29
X-BigFish: VS-29(zz9371M1447R542M1432N98dKzz1202hzz8275ch8275bh8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH 02/02] virtio: Add virtio platform driver
Thread-Topic: [PATCH 02/02] virtio: Add virtio platform driver
Thread-Index: AQHML/z3U3/sunchvki5pw3DM4x2pJTKpWhggAFmdQD//9xgIA==
Date: Fri, 24 Jun 2011 04:08:50 +0000
Message-ID: <B8D6CA50DACE9E4AAADE9A4D56FBAAE6166FD3@039-SN1MPN1-004.039d.mgd.msft.net>
References: <20110621102605.1382.90232.sendpatchset@t400s>
	<20110621102623.1382.71841.sendpatchset@t400s>
	<B8D6CA50DACE9E4AAADE9A4D56FBAAE6166661@039-SN1MPN1-004.039d.mgd.msft.net>
 <BANLkTi=QhwBAv5GtrTpitVhx+yDZPnRN+g@mail.gmail.com>
In-Reply-To: <BANLkTi=QhwBAv5GtrTpitVhx+yDZPnRN+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanation. I also thought of same purpose for this patch but I got confused by function names and data structure names in the patch. They still have lguest in it.

Thanks
-Bharat

> -----Original Message-----
> From: Magnus Damm [mailto:magnus.damm@gmail.com]
> Sent: Friday, June 24, 2011 6:44 AM
> To: Bhushan Bharat-R65777
> Cc: linux-kernel@vger.kernel.org; vapier@gentoo.org; mst@redhat.com;
> linux-sh@vger.kernel.org; virtualization@lists.linux-foundation.org
> Subject: Re: [PATCH 02/02] virtio: Add virtio platform driver
> 
> Hi Bhushan Bharat,
> 
> On Thu, Jun 23, 2011 at 5:54 PM, Bhushan Bharat-R65777
> <R65777@freescale.com> wrote:
> > What purpose this virtio platform driver serves? Are you trying to make
> driver layers here and each virtio device driver can hook up into this
> platform driver. Is that correct ?
> 
> The idea behind the virto platform driver is to have a reusable layer
> that handles common virtio and vring functionality. Regular virtio
> drivers for console, network and disk and interfacing to the virtio
> platform driver, so these paravirtualized drivers can with this virtio
> platform driver easily be reused by embedded platforms.
> 
> Vendor specific code is abstracted away from the virtio platform driver
> and interfaced to using regular interrupts and SoC-specific callbacks. So
> with this patch virtio can be interfaced as any regular platform driver.
> This version of the driver is simply reusing the configuration method
> from lguest.
> 
> If you want to see all code involved (including extremely experimental
> backing drivers) then have a look at:
> http://www.spinics.net/lists/linux-sh/msg07188.html
> 
> Cheers,
> 
> / magnus


