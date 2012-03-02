Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2CBLIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:08:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab2CBLIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:08:38 -0500
Message-ID: <4F50AA22.9080007@redhat.com>
Date: Fri, 02 Mar 2012 12:08:18 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com>   <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>   <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>  <4F4FAF89.3090706@redhat.com> <1330624986.11248.209.camel@twins>
In-Reply-To: <1330624986.11248.209.camel@twins>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 07:03 PM, Peter Zijlstra wrote:
> On Thu, 2012-03-01 at 18:19 +0100, Michal Schmidt wrote:
>> Dne 23.2.2012 15:13, Peter Zijlstra napsal:
>>> My utter disregard for cgroups comes from having to actually implement a
>>> controller for them, its a frigging nightmare. The systemd retards
>>> mandating all this nonsense for booting a machine is completely bonghit
>>> inspired and hasn't made me feel any better about it.
>>
>> systemd requires only CONFIG_CGROUPS=y. It does not need any controllers.
>
> And that makes it better how?

Because it is not involved in the controllers nightmare you have.
systemd does not require "all this nonsense".

>> The insults are entirely unnecessary.
>
> I think not, booting a machine should depend on the smallest possible
> subset of features. Doing anything else is completely bonkers.

Your disagreement does not justify calling the people on the other side 
retards.

Your statement about the smallest feature subset could use some 
clarification. Should we make sure everything works fine without, say, 
CONFIG_UNIX?
And what exactly do you mean by booting? Obviously not booting into a 
full desktop environment, because that requires a lot of features.
If on the other hand you are satisfied with booting into a getty with 
not many services around, in this sense systemd will boot without 
CONFIG_CGROUPS. It's recommended not to do that and nobody actively 
tests this setup, but at least systemd will not abort. So it can be used 
to check if the kernel boots and to run some tests.

Michal
