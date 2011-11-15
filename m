Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1KOKkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:40:06 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:25549
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545Ab1KOKkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:40:03 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zz98dK4015Lzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUP6YM-01-1DR-02
X-M-MSG: 
Date: Tue, 15 Nov 2011 11:39:26 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 0/5] OMAP groundwork for IOMMU-based DMA API
Message-ID: <20111115103926.GA5627@amd.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316948337-7924-1-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Sun, Sep 25, 2011 at 06:58:52AM -0400, Ohad Ben-Cohen wrote:
> Ohad Ben-Cohen (5):
>   ARM: dev_archdata: add private iommu extension
>   ARM: OMAP: omap_device: add a method to set iommu private archdata
>   ARM: OMAP: iommu: declare a private iommu binding struct
>   ARM: OMAP3: bind omap3isp_device to its iommu device
>   iommu/omap: eliminate the public omap_find_iommu_device() method

It doesn't apply cleanly, can you please rebase the code, collect the
Acked-by's and resend?

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

