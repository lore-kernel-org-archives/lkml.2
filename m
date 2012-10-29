Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324Ab2J2SVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:21:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44071 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2J2SVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:21:32 -0400
Message-ID: <508EC928.7030900@wwwdotorg.org>
Date: Mon, 29 Oct 2012 12:21:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] ARM: tegra: dts: add slink controller dt entry
References: <1351531180-1652-1-git-send-email-ldewangan@nvidia.com> <1351531180-1652-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1351531180-1652-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 11:19 AM, Laxman Dewangan wrote:
> Add slink controller details in the dts file of
> Tegra20 and Tegra30.

> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi

> +	slink@7000d400 {

I think the node names should be spi@..., since the generic controller
type is SPI, even if NVIDIA happens to called the controllers SLINK and SBC.
