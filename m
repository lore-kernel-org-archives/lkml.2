Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2ATQE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:04:57 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:27497
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab2ATQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:04:56 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LY3U03-02-GXW-02
X-M-MSG: 
Date: Fri, 20 Jan 2012 17:03:44 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120120160344.GG2205@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
 <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 05:16:48PM +0000, Sethi Varun-B16395 wrote:
> >  struct iommu_domain {
> >  	struct iommu_ops *ops;
> >  	void *priv;
> >  	iommu_fault_handler_t handler;
> > +	struct iommu_domain_geometry geometry;
> >  };
> In case of our iommu implementation the iommu_domain_geometry would
> include additional attributes. Why can't we let the geometry be
> Implementation dependent?

Because the values in this generic geometry-struct make sense for more
than one IOMMU (short-term for Tegra GART and Freescale PAMU). If you
have additional vendor-specific ones you could add them via a
vendor-specific attribute.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

