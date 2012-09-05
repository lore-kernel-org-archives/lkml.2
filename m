Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2IEEjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:39:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16011 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2IEEjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:39:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 04 Sep 2012 21:39:28 -0700
Date: Wed, 5 Sep 2012 07:39:25 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] dma: tegra: move smmu.h into SMMU driver
Message-ID: <20120905073925.4a2234eed1d53b9db4e97871@nvidia.com>
In-Reply-To: <1346798175-28733-1-git-send-email-swarren@wwwdotorg.org>
References: <1346798175-28733-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012 00:36:15 +0200
Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
> 
> There's no need to place these defines into arch/arm/mach-tegra/include/.
> Move them into the SMMU driver to clean up mach-tegra, as a pre-requisite
> for single-zImage.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Cc: Hiroshi Doyu <hdoyu@nvidia.com>

Ok to me. Acked-by: Hiroshi Doyu <hdoyu@nvidia.com>
