Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1K1FfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:35:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1K1FfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:35:24 -0500
Message-ID: <4ED31D80.9090404@redhat.com>
Date: Mon, 28 Nov 2011 13:34:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Breeds <tbreeds@au1.ibm.com>
Subject: Re: [V2 PATCH 00/62] highmem: remove the second argument of kmap_atomic/kunmap_atomic
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>	 <1322432495.23348.1.camel@pasglop> <1322454868.23348.38.camel@pasglop>
In-Reply-To: <1322454868.23348.38.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月28日 12:34, Benjamin Herrenschmidt 写道:
> On Mon, 2011-11-28 at 09:21 +1100, Benjamin Herrenschmidt wrote:
>> On Sun, 2011-11-27 at 13:26 +0800, Cong Wang wrote:
>>> V1: https://lkml.org/lkml/2011/1/30/13
>>>
>>> V1->V2: Split patches and rebase them to the latest linus tree.
>>
>> I'm not too fan of the split myself... 62 patches is just plain crazy.
>> However, no obvious objection from the patches themselves (at least the
>> ones affecting powerpc), though I haven't had a chance to test them yet.
>
> So Tony tested for me (thanks !) and it looks all fine.
>
> For the powerpc parts
>
> Acked-by: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>

Thanks for review and tests!
