Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0E3OH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 10:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0E3OH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 10:07:57 -0400
Message-ID: <4C027131.2010309@redhat.com>
Date: Sun, 30 May 2010 17:07:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
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
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>	 <1275083157.22648.593.camel@gandalf.stny.rr.com>	 <4C00FF9B.9000107@redhat.com>	 <1275139177.22648.610.camel@gandalf.stny.rr.com>	 <4C021D7E.1060705@redhat.com> <1275228182.15884.1.camel@gandalf.stny.rr.com>
In-Reply-To: <1275228182.15884.1.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 05:03 PM, Steven Rostedt wrote:
>
>> Right.  The tools can fall back to %x/%s based on the structure
>> descriptor if they can't parse the format string.
>>
>>      
> trace-cmd has plugin support to override how to read the format and
> print it out. It now has the ability to write those plugins in python.
>    

Cool.  May make sense to use simpler formatting in the kernel, and use 
trace-cmd plugins for the complicated cases.

It does raise issues with ABIs.  Can trace-cmd read plugins from 
/lib/modules/*?  We can then distribute the plugins with the kernel.

-- 
error compiling committee.c: too many arguments to function

