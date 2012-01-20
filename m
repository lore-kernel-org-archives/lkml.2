Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2ATQDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:03:13 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31472 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2ATQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:03:10 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dhc1bhc31hc1ah668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY3TWI-02-GR0-02
X-M-MSG: 
Date: Fri, 20 Jan 2012 17:01:28 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120120160128.GF2205@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <201201191646.13798.laurent.pinchart@ideasonboard.com>
 <20120119160739.GB2205@amd.com>
 <201201191727.10176.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201201191727.10176.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 05:27:09PM +0100, Laurent Pinchart wrote:
> > Well, u64 is a catch-all datatype which should suit all drivers. Is this
> > a problem at ARM?
> 
> No, it's not a problem for ARM, at least to my knowledge. It just struck me as 
> weird, as we have specific data types for other kinds of addresses (such as 
> dma_addr_t).

Okay, I looked at the definition and dma_addr_t seems like a good fit.
To be consistent we should change the iova type of the map/unmap
functions to dma_addr_t too.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

