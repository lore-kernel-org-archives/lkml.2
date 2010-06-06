Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0FFQWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0FFQWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:22:16 -0400
Message-ID: <4C0BCB27.1050601@redhat.com>
Date: Sun, 06 Jun 2010 19:21:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
Subject: Re: Perf trace event parse errors for KVM events
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>	 <1275083157.22648.593.camel@gandalf.stny.rr.com>	 <4C00FF9B.9000107@redhat.com>	 <1275139177.22648.610.camel@gandalf.stny.rr.com>	 <4C021D7E.1060705@redhat.com>	 <1275228182.15884.1.camel@gandalf.stny.rr.com>	 <4C027131.2010309@redhat.com>	 <1275233656.15884.4.camel@gandalf.stny.rr.com>	 <4C04C739.8050607@redhat.com>	 <1275393544.15884.19.camel@gandalf.stny.rr.com>	 <4C04FF65.8020408@redhat.com>	 <1275602225.15884.47.camel@gandalf.stny.rr.com>	 <4C0B577F.9050506@redhat.com> <1275836555.15884.83.camel@gandalf.stny.rr.com>
In-Reply-To: <1275836555.15884.83.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 06:02 PM, Steven Rostedt wrote:
> On Sun, 2010-06-06 at 11:08 +0300, Avi Kivity wrote:
>
>    
>>> Also, I kicked this off in kernelshark, and it made no difference that I
>>> can see. This is because kernelshark only evaluates the viewable area of
>>> the screen.
>>>
>>>        
>> Neat.  Can it also search?  Where can I find it?<googles, finds, gawks>
>>
>>      
> It's in the same repo as trace-cmd:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
>
> I'm still working on it. The latest is in the branch kernelshark-devel.
>
> And yes, it does searches.
>    

I'll be tracking it.

In case you're interested in wishlists, my #1 would be to be able to 
initiate traces from the GUI (so it's easy to explore the available 
trace events and enable them interactively).

-- 
error compiling committee.c: too many arguments to function

