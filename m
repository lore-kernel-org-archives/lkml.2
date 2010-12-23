Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0LWOEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:04:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0LWOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:04:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Thu, 23 Dec 2010 15:04:07 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
In-reply-to: <20101223134838.GK3636@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        "'Johan MOSSBERG'" <johan.xx.mossberg@stericsson.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>
Message-id: <4D1356D7.2000008@samsung.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Thunderbird/3.1.7
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
 <20101223100642.GD3636@n2100.arm.linux.org.uk>
 <00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
 <20101223121917.GG3636@n2100.arm.linux.org.uk> <4D135004.3070904@samsung.com>
 <20101223134838.GK3636@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-23 14:48, Russell King - ARM Linux wrote:
> On Thu, Dec 23, 2010 at 02:35:00PM +0100, Tomasz Fujak wrote:
>> Dear Mr. King,
>>
>> AFAIK the CMA is the fourth attempt since 2008 taken to solve the
>> multimedia memory allocation issue on some embedded devices. Most
>> notably on ARM, that happens to be present in the SoCs we care about
>> along the IOMMU-incapable multimedia IPs.
>>
>> I understand that you have your guidelines taken from the ARM
>> specification, but this approach is not helping us.
> I'm sorry you feel like that, but I'm living in reality.  If we didn't
> have these architecture restrictions then we wouldn't have this problem
> in the first place.
Do we really have them, or just the documents say they exist?
> What I'm trying to do here is to ensure that we remain _legal_ to the
> architecture specification - which for this issue means that we avoid
> corrupting people's data.
As legal as the mentioned dma_coherent?
> Maybe you like having a system which randomly corrupts people's data?
> I most certainly don't.  But that's the way CMA is heading at the moment
> on ARM.
Has this been experienced? I had some ARM-compatible boards on my desk
(xscale, v6 and v7) and none of them crashed due to this behavior. And
we *do* have multiple memory mappings, with different attributes.
> It is not up to me to solve these problems - that's for the proposer of
> the new API to do so.  So, please, don't try to lump this problem on
> my shoulders.  It's not my problem to sort out.
Just great. Nothing short of spectacular - this way the IA32 is going to
take the embedded market piece by piece once the big two advance their
foundry processes.
Despite having the translator, so much burden in the legacy ISA and the
fact that most of the embedded engineers from the high end are
accustomed to the ARM.

In other words, should we take your response as yet another NAK?
Or would you try harder and at least point us to some direction that
would not doom the effort from the very beginning.
I understand that the role of an oracle is so much easier, but the time
is running and devising subsequent solutions is not the use of
engineers' time.

Best regards
---
Tomasz Fujak

> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

