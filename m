Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2GXIpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:45:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19134 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2GXIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:45:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 24 Jul 2012 01:45:15 -0700
Date: Tue, 24 Jul 2012 11:45:11 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Joerg Roedel" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 5/7] drivers/iommu/tegra-smmu.c: remove invalid
 reference to list iterator variable
Message-ID: <20120724114511.2315bf9f76165bad5af37ce6@nvidia.com>
In-Reply-To: <500D90F9.7030909@wwwdotorg.org>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
	<1341747464-1772-6-git-send-email-Julia.Lawall@lip6.fr>
	<500D90F9.7030909@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Mon, 23 Jul 2012 19:59:21 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 07/08/2012 05:37 AM, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Julia,
> 
> It looks like this patch hasn't seen any replies since you didn't CC the
> maintainers of this code. I've CC'd them now.
> 
> > If list_for_each_entry, etc complete a traversal of the list, the iterator
> > variable ends up pointing to an address at an offset from the list head,
> > and not a meaningful structure.  Thus this value should not be used after
> > the end of the iterator.  Replace c->dev by dev, which is the value that
> > c->dev has been compared to.
> > 
> > This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Acked-by: Hiroshi DOYU <hdoyu@nvidia.com>
Ok to me too. Thanks.
