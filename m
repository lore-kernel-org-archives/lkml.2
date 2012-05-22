Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2EVG6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:58:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45050 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2EVG6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:58:40 -0400
X-AuditID: 9c93016f-b7c3cae000001954-62-4fbb391b74b0
Message-ID: <4FBB391F.8030402@kernel.org>
Date: Tue, 22 May 2012 15:58:39 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.ports.arm.kernel,gmane.linux.kernel
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCHv2 1/4] mm: vmalloc: use const void * for caller argument
References: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com> <1337252085-22039-2-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1337252085-22039-2-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 07:54 PM, Marek Szyprowski wrote:

> 'const void *' is a safer type for caller function type. This patch
> updates all references to caller function type.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>


Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
