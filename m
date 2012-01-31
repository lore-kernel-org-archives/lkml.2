Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2AaLDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:03:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6022 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2AaLDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:03:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Jan 2012 03:03:50 -0800
Message-ID: <4F27CA58.2020809@nvidia.com>
Date: Tue, 31 Jan 2012 16:32:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] arm: tegra: dma: not required to move requestor when
 stopping.
References: <1327392649-27605-1-git-send-email-ldewangan@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF178CB81E5F@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178CB81E5F@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 02:27 AM, Stephen Warren wrote:
> Laxman Dewangan wrote at Tuesday, January 24, 2012 1:11 AM:
>> It is not require to move the requestor of dma to INVALID
>> option before stopping dma.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Acked-by: Stephen Warren<swarren@nvidia.com>
> Tested-by: Stephen Warren<swarren@nvidia.com>
>
> I know that Laxman has checked with the HW engineers, and they see no
> reason to do this. I was originally worried about hung FIFOs preventing
> an in-progress DMA from completely without the removed code, but according
> to HW, that isn't a concern.
>
Olaf,
Can it be applied if it is OK to you?

Thanks,
Laxman
