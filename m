Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2GWR72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:59:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46772 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2GWR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:59:25 -0400
Message-ID: <500D90F9.7030909@wwwdotorg.org>
Date: Mon, 23 Jul 2012 11:59:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 5/7] drivers/iommu/tegra-smmu.c: remove invalid reference
 to list iterator variable
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr> <1341747464-1772-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1341747464-1772-6-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 05:37 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>

Julia,

It looks like this patch hasn't seen any replies since you didn't CC the
maintainers of this code. I've CC'd them now.

> If list_for_each_entry, etc complete a traversal of the list, the iterator
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.  Replace c->dev by dev, which is the value that
> c->dev has been compared to.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
