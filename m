Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2KUPun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:50:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2KUPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:50:41 -0500
Message-ID: <50ACF847.3070709@samsung.com>
Date: Thu, 22 Nov 2012 00:50:31 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v3 02/12] ARM: EXYNOS: Add clk_ops for gating clocks of
 System MMU
References: <002801cdc7a5$8535f6d0$8fa1e470$%cho@samsung.com>
In-Reply-To: <002801cdc7a5$8535f6d0$8fa1e470$%cho@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/12 14:03, Cho KyongHo wrote:
> Touching some System MMU needs its master devices' clock to be enabled
> before. This commit adds clk_ops.set_parent of gating clocks of System
> MMU to ensure gating clocks of System MMU's mater devices are enabled
> when enabling gating clocks of System MMU.
>
> Change-Id: Icd58b12f599e92692c032516331a444f4703ba6b

Same here, we don't need this :-)

> Signed-off-by: KyongHo Cho<pullip.cho@samsung.com>
> ---
>   arch/arm/mach-exynos/clock-exynos5.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>

Looks good to me, and I think, this can be applied independently from 
this series. Will apply with removing 'Change-Id'.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
