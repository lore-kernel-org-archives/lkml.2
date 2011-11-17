Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1KQQuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:50:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16475 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab1KQQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:50:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 17 Nov 2011 08:49:43 -0800
Date: Thu, 17 Nov 2011 18:49:41 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 00/10] Add support for tegra30 and cardhu
Message-ID: <20111117164941.GU19069@tbergstrom-lnx.Nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:19:14PM +0100, Peter De Schrijver wrote:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Pathset is on top of Will Deacon's ARM reset work, my patch to convert tegra20
> to GIC devicetree binding and my patch to make clk_get not fatal.
> 

I just noticed the clk_get not fatal patch is already in linux-next.

Cheers,

Peter.
