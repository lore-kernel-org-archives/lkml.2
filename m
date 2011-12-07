Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1LGJ1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:27:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1LGJ1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:27:20 -0500
Message-ID: <4EDF3160.7070800@redhat.com>
Date: Wed, 07 Dec 2011 17:26:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] highmem: Fix ARM build break due to __kmap_atomic rename
References: <1323197426-10815-1-git-send-email-swarren@nvidia.com> <alpine.LFD.2.02.1112061440050.2357@xanadu.home> <74CDBE0F657A3D45AFBB94109FB122FF1750B774A6@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B774A6@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月07日 03:52, Stephen Warren 写道:
> Nicolas Pitre wrote at Tuesday, December 06, 2011 12:42 PM:
>> On Tue, 6 Dec 2011, Stephen Warren wrote:
>>> Git commit 37bfbb9 "highmem: kill all __kmap_atomic()" renamed
>>> __kmap_atomic to kmap_atomic. However, arch/arm/include/asm/highmem.h
>>> wasn't updated for that change. This change does so, and fixes the
>>> ARM build break.
>>>
>>> Signed-off-by: Stephen Warren<swarren@nvidia.com>
>>> ---
>>> This shows up in next-20111206 at least.
>>
>> Commit 37bfbb9 doesn't show up in anything which is stable yet.  Would
>> be best to ask the original author to fix his branch.
>
> Yes, I assumed that Cong would squash this into his/her tree that's in
> linux-next.
>

Thanks for your patch, Stephen!

I have squashed your patch into that commit,

commit 5bf31c9a5de45a6ea6628fe84c043ac38babf393
Author: Cong Wang <amwang@redhat.com>
Date:   Sat Nov 26 10:53:39 2011 +0800

     highmem: kill all __kmap_atomic()
     [swarren@nvidia.com: highmem: Fix ARM build break due to __kmap_atomic rename]

     Signed-off-by: Stephen Warren <swarren@nvidia.com>
     Signed-off-by: Cong Wang <amwang@redhat.com>

