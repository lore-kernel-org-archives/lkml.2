Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2GKMRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:17:15 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16222
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab2GKMRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:17:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz98dIzz1202hzz15d4Rz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6ZWSF-01-4ZV-02
X-M-MSG: 
Date: Wed, 11 Jul 2012 14:17:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120711121708.GF25282@amd.com>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
 <1342003763-8139-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D13AA64@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D13AA64@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sethi,

On Wed, Jul 11, 2012 at 11:47:39AM +0000, Sethi Varun-B16395 wrote:
> I am currently working on upstreaming the Freescale IOMMU driver. As
> discussed (with Scott Wood) a while back, this representation of the
> GEOMETRY attribute doesn't go well with our IOMMU implementation. Our
> representation of the geometry would be more complex and is certainly
> modifiable.  Our IOMMU allows for creating custom DMA mappings by
> defining a set of DMA sub windows within a given window. We need a
> mechanism for specifying the number of DMA subwindows as a part of the
> domain geometry. My suggestion would be to make the GEOMETRY attribute
> implementation dependent

Yeah, we had some discussions in the past and I came to the conclusion
that its best to wait for your code and decide then if and how to
change the interface to better suit your needs. The interface is not
exposed to userspace so we can easily change it.

People are waiting for this feature and I don't want to delay it further
unless it is absolutly necessary.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

