Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2JRWl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:41:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34844 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2JRWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:41:28 -0400
Message-ID: <50808595.8070505@wwwdotorg.org>
Date: Thu, 18 Oct 2012 16:41:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: tegra: dts: add slink controller dt entry
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1350557795-31487-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
> Add slink controller details in the dts file of
> Tegra20 and Tegra30.

> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi

> +	slink@7000d400 {
> +		compatible = "nvidia,tegra20-slink";
> +		reg = <0x7000d400 0x200>;
> +		interrupts = <0 59 0x04>;
> +		nvidia,dma-req-sel = <15>;

I thought the common DT DMA bindings were going to be in 3.7, and hence
we could just use them here rather than inventing another custom
property for this purpose?
