Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab2JMEXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 00:23:23 -0400
Received: from mail.lemote.com ([222.92.8.141]:51985 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab2JMEXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 00:23:21 -0400
Message-ID: <2649.121.227.41.141.1350099577.squirrel@mail.lemote.com>
Date: Sat, 13 Oct 2012 11:39:37 +0800 (CST)
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()" 
     should be reverted in 3.5 branch
From: =?gb2312?Q?=B3=C2=BB=AA=B2=C5?= <chenhc@lemote.com>
To: "Charles Wang" <muming.wq@gmail.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Jonathan Nieder" <jrnieder@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Charles Wang" <muming.wq@taobao.com>,
        "Ingo Molnar" <mingo@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I still think that "sched: Add missing call to calc_load_exit_idle()"
should be reverted in 3.5 branch...

> On 10/06/2012 01:23 AM, Peter Zijlstra wrote:
>> On Fri, 2012-10-05 at 10:10 -0700, Jonathan Nieder wrote:
>>> Peter Zijlstra wrote:
>>>> On Thu, 2012-10-04 at 15:27 -0700, Greg Kroah-Hartman wrote:
>>>
>>>>> I'm puzzled as well.  Any ideas if I should do anything here or not?
>>>>
>>>> So I think the current v3.5.5 code is fine.
>>>
>>> Now I'm puzzled.  You wrote:
>>>
>>> | However, since we don't restart the tick, we won't be sampling load
>>> muck
>>> | and calling calc_load_exit_idle() from there is bound to confuse
>>> state.
>>>
>>> Doesn't that mean 900404e5d201 "sched: Add missing call to
>>> calc_load_exit_idle()" which is part of 3.5.5 was problematic?  Or
>>> did I just miscount the number of "not"s?
>>
>>
>> Argh, yeah, so now I've managed to confuse everyone I'm afraid.
>>
>> You are right, v3.5.5 has one calc_load_exit_idle() too many, the one in
>> tick_nohz_update_jiffies() needs to go.
>>
>> Sorry.. I got entirely confused figuring out wth happened with 3.6.
>>
> High loadavg reported with v3.6, and I just checked the upstream code,
> which puzzled many people. Sorry for that~
>

