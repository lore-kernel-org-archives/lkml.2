Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2H1Qvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:51:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32856 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2H1Qvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:51:41 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-77-503cf71c55b6
Message-id: <503CF6F4.7060702@samsung.com>
Date: Tue, 28 Aug 2012 18:51:00 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713
 Thunderbird/14.0
MIME-version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, vdumpa@nvidia.com, subashrp@gmail.com,
        minchan@kernel.org, pullip.cho@samsung.com, konrad.wilk@oracle.com,
        linux-tegra@vger.kernel.org
Subject: Re: [v4 0/4] ARM: dma-mapping: IOMMU atomic allocation
References: <1346130784-23571-1-git-send-email-hdoyu@nvidia.com>
In-reply-to: <1346130784-23571-1-git-send-email-hdoyu@nvidia.com>
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAV2Z7zYBBr/OCFpc3jWHzaLzyyw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDIu9CxhLPjGWnF4ZQt7A+MLli5GTg4JAROJd883MEHY
	YhIX7q1n62Lk4hASWMQoMattLiuE85pRovtnIyNIFa+AlsTxltWsIDaLgKrElLXnwWw2AUOJ
	rrddbCC2qECwxNwVR1kg6gUlfky+B2aLCChLvN11A2wos8BzJom7P1cBJTg4hAXsJZZcLgep
	ERJwkFi8fxPYLk4BR4l1C3Ywg9jMAtYSTfuuQNnyEpvXvGWewCgwC8mKWUjKZiEpW8DIvIpR
	NLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOBifSe9gXNVgcYhRgINRiYc3YJd1gBBrYllxZe4h
	RgkOZiUR3nPXbAKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8/L3GQYICaQnlqRmp6YWpBbBZJk4
	OKUaGPV0V5VrF0yXvX/mthhH2fxri94sO7UxmbtIYFeG/IP+zEurmDb95I2v/j7PZ/Y0rtdW
	Umc8pZ5MSXiStPXW343Vamz7fi6S15zUc3nmXK/WFLZT4TFyb7mNhXk25K989oNZ75V4rfPL
	L6YeH9ZseP/ddGlNofzbOof9Vz0TDXKt2feXex/OzFRiKc5INNRiLipOBACj8xpzQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 8/28/2012 7:13 AM, Hiroshi Doyu wrote:
> The commit e9da6e9 "ARM: dma-mapping: remove custom consistent dma
> region" breaks the compatibility with existing drivers. This causes
> the following kernel oops(*1). That driver has called dma_pool_alloc()
> to allocate memory from the interrupt context, and it hits
> BUG_ON(in_interrpt()) in "get_vm_area_caller()". This patch seris
> fixes this problem with making use of the pre-allocate atomic memory
> pool which DMA is using in the same way as DMA does now.
>
> Any comment would be really appreciated.

Looks fine now. I will do some tests and apply them to my fixes-for-3.6
branch. Thanks for Your contribution!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
