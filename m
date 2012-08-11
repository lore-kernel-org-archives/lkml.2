Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2HKSjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 14:39:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2HKSje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 14:39:34 -0400
Message-ID: <5026A6D1.8070403@zytor.com>
Date: Sat, 11 Aug 2012 11:39:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>, amwang@redhat.com,
        dyoung@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, xiyou.wangcong@gmail.com, rjw@sisk.pl,
        yinghai.lu@oracle.com, tiwai@suse.de, kexec@lists.infradead.org
CC: Tejun Heo <tj@kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
References: <1339478463-31172-1-git-send-email-amwang@redhat.com> <5004D8BF.6050205@jp.fujitsu.com> <500D20A1.1030800@redhat.com> <500D340F.5080801@jp.fujitsu.com> <1343145331.16290.45.camel@cr0> <500F3B7C.70009@jp.fujitsu.com> <20120811175759.GA1814@cantor.Home> <20120811182644.GA1787@cantor.Home> <5026A5AE.6050608@zytor.com>
In-Reply-To: <5026A5AE.6050608@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 11:34 AM, H. Peter Anvin wrote:
> On 08/11/2012 11:26 AM, Jerry Snitselaar wrote:
>>>
>>> This patch from Jacob Shin solves the problem, and seems like it might
>>> be a better solution.
>>>
>>> [PATCH 2/5] x86: find_early_table_space based on memory ranges that
>>> are being mapped
>>>
>>> https://lkml.org/lkml/2012/8/9/540
>>>
>> Actually, apply that series of 5 patches.
>>
>
> I was hoping Tejun would comment on it, but I think I'll pull it into -tip.
>
> However, the real question is what we should do for -stable; applying
> the full patch series seems a big aggressive for that.  On the other
> hand, if it really is The Right Thing then perhaps we should do so anyway.
>

Ah, right... still waiting for a rev of the patch to address Yinghai's 
legitimate request for minor code restructuring.  Other than that, the 
patchset is really The Right Thing.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

