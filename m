Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2KADrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:47:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1850 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2KADrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:47:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Oct 2012 20:47:40 -0700
Message-ID: <5091F076.6030507@nvidia.com>
Date: Thu, 1 Nov 2012 09:15:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com> <50915203.8030505@wwwdotorg.org> <5091607D.8010907@nvidia.com> <5091791F.4080400@wwwdotorg.org>
In-Reply-To: <5091791F.4080400@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012 12:46 AM, Stephen Warren wrote:
> On 10/31/2012 11:31 AM, Laxman Dewangan wrote:
>> On Wednesday 31 October 2012 09:59 PM, Stephen Warren wrote:
>>> On 10/31/2012 03:02 AM, Laxman Dewangan wrote:
>>>> This series modify the dts file to add the slink addresses,
>>>> make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and
>>>> enable slink controller defconfig.
>>> I don't appear to have received patch 1/4 this time around. I'll assume
>>> it's identical to V3, since I don't think anything needed to change
>>> there...
>> Yes, it is identical to V3, no change on the 1/4.
> OK, I have applied the series now. Thanks.
>
> BTW, I noticed that the Cardu board files sets the SPI controller's max
> frequency to 25MHZ (which is consistent with the commit description) but
> the SPI flash node's frequency to 20MHz. Was that intended, or should I
> fix it up to be 25MHz?
If device provide the max frequency then the spi communciation will on 
this requested frequency.
If device does not provide the max spi frequency then it will 
communciate with the controller max frequency.

In this case we provide the 20MHz for device and 25MHz for controller. 
So spi communciation with this device will be always 20MHz.
