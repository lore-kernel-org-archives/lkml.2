Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2DZUBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:01:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33228 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2DZUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:01:40 -0400
Message-ID: <4F99A9A0.1030304@wwwdotorg.org>
Date: Thu, 26 Apr 2012 14:01:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: swarren@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Simon Glass <sjg@chromium.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 4/4] ARM: dt: tegra: Add device tree support for AHB
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com> <1335352072-4001-4-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335352072-4001-4-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> Add AHB entry for tegra20/30.

> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi

> +	ahb: ahb@6000c004 {
> +		compatible = "nvidia,tegra30-ahb", "nvidia,tegra20-ahb";

This should only be tegra20-ahb in the Tegra20 file.
