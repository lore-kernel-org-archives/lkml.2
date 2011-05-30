Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1E3U5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:57:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44276 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1E3U5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:57:14 -0400
Message-ID: <4DE404A5.1040400@sgi.com>
Date: Mon, 30 May 2011 13:57:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Intel pci: Fix various problems with Intel IOMMU
 code
References: <20110528181501.896092225@gulag1.americas.sgi.com> <1306627925.2029.341.camel@i7.infradead.org>
In-Reply-To: <1306627925.2029.341.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/28/2011 05:12 PM, David Woodhouse wrote:
> On Sat, 2011-05-28 at 13:15 -0500, Mike Travis wrote:
>> 	Various problems exist in the Intel IOMMU PCI driver when
>> 	using DMA remapping in 1:1 identity mode on UV systems and
>> 	devices cannot address all of physical memory.
>>
>> 	This patchset addresses those problems.
>
> Patches 1-6 applied to iommu-2.6.git. Please test. Thanks.
>
> Please note for future reference that 'From:' lines such as the one in
> your patch 1/7 should be *first* in the body of your email. The git-am
> tool doesn't find them and set the authorship if you put them with the
> Signed-off-bys. Also please avoid putting whitespace at the beginning of
> every line of your commit comments.
>
> I still hate patch 7, but the point was that I wouldn't have to care
> about it. Once your patches 1-6 are included in known stable releases
> that your SCU can recognise, it can just pass 'iommu=pt' for those.
>
> It's only the "probably buggy" kernels with older release numbers that
> you'll pass 'forcedac,pt64' to, so your mission is to get patch 7 or
> some variant of it accepted into *those* kernels.
>

Thanks David, all noted.  The From: thing is swallowed by the
quilt mail command if it's first.  I'll see if I can't fix that.

Cheers.
