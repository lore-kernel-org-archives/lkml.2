Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab2JaRf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:35:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14233 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab2JaRfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:35:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 31 Oct 2012 10:35:21 -0700
Message-ID: <509160F5.9070400@nvidia.com>
Date: Wed, 31 Oct 2012 23:03:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com> <509038BA.30600@wwwdotorg.org> <5090E69C.4080108@nvidia.com> <50914C82.5010704@wwwdotorg.org>
In-Reply-To: <50914C82.5010704@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 09:36 PM, Stephen Warren wrote:
> On 10/31/2012 02:51 AM, Laxman Dewangan wrote:
>
> I had forgotten about this from when I tested the older SPI driver that
> we ripped out; I had at least compared the registers between U-Boot and
> the kernel with that driver, so I'm pretty sure I didn't make that
> mistake with the old driver.
>
> So, I'll apply your patch series, and send one to add the flash device
> to the Cardhu .dts.

Great  to hear that the spi driver work for you now.

Thanks,
Laxman
