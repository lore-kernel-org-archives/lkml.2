Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3ABTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:19:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52942 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3ABTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:19:54 -0500
Message-ID: <50E48853.5080703@wwwdotorg.org>
Date: Wed, 02 Jan 2013 12:19:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial
 controller
References: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 11:31 PM, Laxman Dewangan wrote:
> Add APB DMA requestor and serial aliases for serial controller.
> There will be two serial driver i.e. 8250 based simple serial driver
> and APB DMA based serial driver for higher baudrate and performace.
> 
> The simple serial driver get enabled with compatible nvidia,tegra20-uart
> and APB DMA based driver will get enabled with compatible
> nvidia,tegra20-hsuart.

I've applied this to Tegra's for-3.9/dt branch.

