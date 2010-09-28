Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0I1NZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:25:41 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:20854 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753802Ab0I1NZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:25:39 -0400
Message-ID: <4CA1EC0E.2020304@snapgear.com>
Date: Tue, 28 Sep 2010 23:22:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 08/20] m68knommu: change to new flag variables
References: <1285224645-29728-1-git-send-email-mfm@muteddisk.com> <4CA18E00.7090207@snapgear.com> <20100928071606.GA13303@haskell.muteddisk.com>
In-Reply-To: <20100928071606.GA13303@haskell.muteddisk.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2010 13:22:40.0621 (UTC) FILETIME=[39EE11D0:01CB5F10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Matt,

On 28/09/10 17:16, matt mooney wrote:
> On 16:41 Tue 28 Sep     , Greg Ungerer wrote:
>>
>> Hi Matt,
>>
>> On 23/09/10 16:50, matt mooney wrote:
>>> Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.
>>>
>>> Signed-off-by: matt mooney<mfm@muteddisk.com>
>>
>> Looks fine to me. Are you looking for this to go through
>> maintainer trees, or the whole patch series in one go?
>
> Hi Greg,
>
> My original intent was through the maintainer trees; however, I am starting to
> realize that it probably would have been best to all go into the kbuild tree as
> one patch series. That being said, some people have picked them up and others
> have just acked, so really whatever is easiest for you. All unapplied will
> eventually go through the kbuild tree.

I am happy to pick up the m68knommu change and send up-stream.

Regards
Greg


>> Acked-by: Greg Ungerer<gerg@uclinux.org>
>>
>> Regards
>> Greg
>>
>>
>>> ---
>>>   arch/m68knommu/platform/5206/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/5206e/Makefile    |    4 ++--
>>>   arch/m68knommu/platform/520x/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/523x/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/5249/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/5272/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/527x/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/528x/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/5307/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/532x/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/5407/Makefile     |    4 ++--
>>>   arch/m68knommu/platform/coldfire/Makefile |    4 ++--
>>>   12 files changed, 24 insertions(+), 24 deletions(-)
>>>

