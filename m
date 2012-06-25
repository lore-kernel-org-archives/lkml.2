Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2FYKnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:43:37 -0400
Received: from [216.32.180.11] ([216.32.180.11]:27717 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab2FYKnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:43:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dI98dI9371I1432Izz1202hzz15d4R8275bh8275dhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M665RI-02-00K-02
X-M-MSG: 
Date: Mon, 25 Jun 2012 12:42:09 +0200
From: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [v2 1/5] iommu: Add DMA window parser, of_get_dma_window()
Message-ID: <20120625104209.GR2624@amd.com>
References: <4FE20457.8090307@wwwdotorg.org>
 <20120621.094611.2108645748323641310.hdoyu@nvidia.com>
 <4FE2C5F3.1010007@wwwdotorg.org>
 <20120621.113023.1324461719984328307.hdoyu@nvidia.com>
 <4FE34973.1020400@wwwdotorg.org>
 <20120625081543.bf25af1f74d7d1057d9cd216@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120625081543.bf25af1f74d7d1057d9cd216@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 08:15:43AM +0300, Hiroshi Doyu wrote:
> On Thu, 21 Jun 2012 18:18:59 +0200
> Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > On 06/21/2012 02:30 AM, Hiroshi Doyu wrote:
> > > From: Hiroshi DOYU <hdoyu@nvidia.com>
> > > 
> > > This code was based on:
> > >     "arch/microblaze/kernel/prom_parse.c"
> > >     "arch/powerpc/kernel/prom_parse.c"
> > > 
> > > Can replace "of_parse_dma_window()" in the above. This supports
> > > different formats flexibly. "prefix" can be configured if any. "busno"
> > > and "index" are optionally specified. Set NULL and 0 if not used.
> > > 
> > > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > 
> > Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> Thanks.
> 
> > BTW, I only see patches 1 & 2 of 5 in this series; did you only mean to
> > post just 2 patches or did the others get lost on the way to my system
> > somehow?
> 
> I reposted only [1/5] and [2/5] as "v2" because the rests are
> same. Probably it was better to send a whole series again. Sorry for
> confusion.

Please repost the whole series with the Acks included as a new thread so
that I can easily apply them.


	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

