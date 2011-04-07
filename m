Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1DGGJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 02:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1DGGJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 02:09:54 -0400
Message-ID: <4D9D55EF.3090606@redhat.com>
Date: Thu, 07 Apr 2011 02:13:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH] sched: recover sched_yield task running time increase
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>	 <1302077064.2225.1357.camel@twins> <1302145733.15889.7472.camel@debian>
In-Reply-To: <1302145733.15889.7472.camel@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 11:08 PM, Alex,Shi wrote:
> On Wed, 2011-04-06 at 16:04 +0800, Peter Zijlstra wrote:
>> On Wed, 2011-04-06 at 06:33 +0800, Alex Shi wrote:

>> You do know that any app that relies on sched_yield behaviour is more
>> than broken? Using sched_yield() for anything other than SCHED_FIFO
>> tasks is well outside spec.
>>
>> Furthermore, apparently you used sysctl_sched_compat_yield, which was
>> bound to disappear some time, since with the default settings the yield
>> semantics didn't actually change.
>
> Yes, I used sched_compat_yield, otherwise volano will become extremely
> slow in my single machine testing. We may reconsider our testing
> setting.

With what JVM is this happening?

Surely not every JVM uses user space spinlocks and
yield, when we have futexes available?



