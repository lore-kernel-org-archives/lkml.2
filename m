Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2LCIwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:52:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50234 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LCIv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:51:58 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-a6-50bc682c5f35
Message-id: <50BC6829.4060205@samsung.com>
Date: Mon, 03 Dec 2012 09:51:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: shuah.khan@hp.com, a-jacquiot@ti.com, fenghua.yu@intel.com,
        catalin.marinas@arm.com, lethal@linux-sh.org, benh@kernel.crashing.org,
        ralf@linux-mips.org, tony.luck@intel.com, davem@davemloft.net,
        msalter@redhat.com, monstr@monstr.eu,
        Ming Lei <ming.lei@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        shuahkhan@gmail.com
Subject: Re: [PATCH 0/9] dma_debug: add debug_dma_mapping_error support to
 architectures that support DMA_DEBUG_API
References: <1353706142.5270.93.camel@lorien2> <50B34B0F.3080204@samsung.com>
 <20121202140644.GP30633@8bytes.org>
In-reply-to: <20121202140644.GP30633@8bytes.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xK7o6GXsCDHbfErT40PGO1eLyrjls
	FnP+TGG2aDi5gtWBxePzJrkAxigum5TUnMyy1CJ9uwSujKXL0wq+sFUcnnuTrYFxH2sXIweH
	hICJxJXdbl2MnECmmMSFe+vZuhi5OIQEljJKvNw7ixXCaWaS2LLiORtIFa+AlsSvQ//ZQWwW
	AVWJFR0zWUFsNgFDia63XWA1ogK+EtN+XWOCqBeU+DH5HguILSKgJHH9cytYPbPAKRaJhlPu
	ILawQKlEx+9nzCC2kECxRNvX60wgx3EKGEg8eFMLUW4m8ahlHTOELS+xec1b5gmMArOQbJiF
	pGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC8+sOxqXHrA4xCnAwKvHwPviy
	O0CINbGsuDL3EKMEB7OSCG+U9Z4AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzmavI/6057BGzZ
	kvNLyZIxfr1fTf87xz7xkulFspFtS9edtPpv6PFzurx4Q7pUf7/8d1OJb5kc0syP76YLLWNb
	0mr0ifHG0b3c940inzhOEuM2XN940lfto7LC56MSWZrLbmadzj73YUL8nacegoo16nzLpzGq
	Wt05cC3o1icB/5dR/pZd3kosxRmJhlrMRcWJAEpHyJorAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/2/2012 3:06 PM, Joerg Roedel wrote:
> Hi Marek,
>   
> On Mon, Nov 26, 2012 at 11:57:19AM +0100, Marek Szyprowski wrote:
>
> > I've took all the patches to the next-dma-debug branch in my tree, I sorry
> > that You have to wait so long for it. My branch is based on Joerg's
> > dma-debug branch and I've included it for testing in linux-next branch.
>
> The patches are now two times in next. One version from my tree and one
> from yours. Please remove the version from your tree, the patches should
> go upstream via my dma-debug branch.

Ok, I've removed them from my dma-mapping-next tree. Please add/cherry-pick
the missing patch for ARM architecture, which I've accidentally already
pushed to mainline some time ago and then reverted. See commit
871ae57adc5ed092 (and 697575896670ba).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


