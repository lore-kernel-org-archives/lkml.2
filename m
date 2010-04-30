Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab0D3RWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:22:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab0D3RVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:36 -0400
Message-ID: <4BDA863A.9060702@redhat.com>
Date: Fri, 30 Apr 2010 10:26:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com> <20100429180955.GA17909@amt.cnet> <4BD9D35C.5090403@redhat.com> <4BDA3F9B.8040708@cn.fujitsu.com>
In-Reply-To: <4BDA3F9B.8040708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 05:25 AM, Lai Jiangshan wrote:
>
>> It's unrelated to TDP, same issue with shadow.  I think the calculation
>> is correct.  For example the 4th spte for a level=2 page will yield
>> gfn=4*512.
>>      
> Avi, Marcelo
> Thank you very much.
>
> The calculation I used is correct.
>    

Yes.  btw, can you update the patch to also correct mmu.txt?

> The fault is comes from the FNAME(fetch) when using shadow page.
>
> I have fix it in the patch
> "[RFC PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages"
>
> (It seems that the mail lists is unreachable, did you receive it?)
>    

The lists are down at the moment.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

