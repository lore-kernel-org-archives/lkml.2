Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab2EJR2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:28:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55235 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2EJR2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:28:32 -0400
Message-ID: <4FABFABC.60407@wwwdotorg.org>
Date: Thu, 10 May 2012 11:28:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/tegra: gart: Fix register offset correctly
References: <1336635940-31068-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336635940-31068-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 01:45 AM, Hiroshi DOYU wrote:
> DT passes the exact GART register ranges without any overlapping with
> MC register ranges. GART register offset needs to be adjusted by one
> passed by DT correctly.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Joerg, I assume you'll take this patch through the iommu tree and I'll
take patch 2 through the Tegra tree?
