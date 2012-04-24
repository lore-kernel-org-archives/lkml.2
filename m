Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2DXTe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:34:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49544 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab2DXTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:34:54 -0400
Message-ID: <4F97005A.2010305@wwwdotorg.org>
Date: Tue, 24 Apr 2012 13:34:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] arm/dts: Tegra30: Add device tree support for SMMU
References: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com> <1335182340-17237-3-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335182340-17237-3-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:58 AM, Hiroshi DOYU wrote:
> Add device tree support for Tegra30 IOMMU(SMMU).

> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi

> +	smmu: smmu@7000f000 {
...
> +		interrupts = <0 13 0x40>;

This interrupt is on the 3rd IRQ controller (or GIC bank) so should be
(2*32)+13, i.e. 75 not 13.
