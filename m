Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2A2Gcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 01:32:54 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48744 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2A2Gcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 01:32:53 -0500
Message-ID: <4F24E804.5090808@linux.vnet.ibm.com>
Date: Sun, 29 Jan 2012 14:32:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Xiaotian Feng <xtfeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com> <4F222B2B.6010602@gmail.com>
In-Reply-To: <4F222B2B.6010602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012906-5564-0000-0000-000001253A72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 12:42 PM, Cong Wang wrote:

> On 01/27/2012 09:22 AM, Michael Wang wrote:
>> Hi, Ingo
>>
>> Thanks for your reply.
>>
>> I have try use "ls -l" to see the size of sched.o, but after applied the
>> patch, it is still 1636.
>>
>> I have not use this method before, may be I use the wrong command...
>>
>> But I think the new code should be similar to the old one after compile,
>> because we still have 3 condition check here.
>>
>> I suppose the new sched.o will be a little bigger, because one jump
>> command and a label need to be added.
>>
> 
> Try to see if `size` helps.

Hi, Cong

Thanks for your advise, but still, the size not changed.

And also I don't know whether the size can be some kind of proof to
confirm the performance improvement in this case...

Thanks,
Michael Wang

> 


