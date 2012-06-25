Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2FYFQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:16:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10094 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2FYFQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:16:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 24 Jun 2012 22:15:47 -0700
Date: Mon, 25 Jun 2012 08:15:43 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [v2 1/5] iommu: Add DMA window parser, of_get_dma_window()
Message-ID: <20120625081543.bf25af1f74d7d1057d9cd216@nvidia.com>
In-Reply-To: <4FE34973.1020400@wwwdotorg.org>
References: <4FE20457.8090307@wwwdotorg.org>
	<20120621.094611.2108645748323641310.hdoyu@nvidia.com>
	<4FE2C5F3.1010007@wwwdotorg.org>
	<20120621.113023.1324461719984328307.hdoyu@nvidia.com>
	<4FE34973.1020400@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 18:18:59 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 06/21/2012 02:30 AM, Hiroshi Doyu wrote:
> > From: Hiroshi DOYU <hdoyu@nvidia.com>
> > 
> > This code was based on:
> >     "arch/microblaze/kernel/prom_parse.c"
> >     "arch/powerpc/kernel/prom_parse.c"
> > 
> > Can replace "of_parse_dma_window()" in the above. This supports
> > different formats flexibly. "prefix" can be configured if any. "busno"
> > and "index" are optionally specified. Set NULL and 0 if not used.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks.

> BTW, I only see patches 1 & 2 of 5 in this series; did you only mean to
> post just 2 patches or did the others get lost on the way to my system
> somehow?

I reposted only [1/5] and [2/5] as "v2" because the rests are
same. Probably it was better to send a whole series again. Sorry for
confusion.
