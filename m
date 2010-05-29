Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0E2LvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab0E2LvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:51:10 -0400
Message-ID: <4C00FF9B.9000107@redhat.com>
Date: Sat, 29 May 2010 14:50:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: Perf trace event parse errors for KVM events
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com> <1275083157.22648.593.camel@gandalf.stny.rr.com>
In-Reply-To: <1275083157.22648.593.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2010 12:45 AM, Steven Rostedt wrote:
> On Fri, 2010-05-28 at 17:42 +0100, Stefan Hajnoczi wrote:
>    
>> I get parse errors when using Steven Rostedt's trace-cmd tool, too.
>>
>> Any ideas what is going on here?  I can provide more info (e.g. trace
>> files) if necessary.
>>      
> Does trace-cmd fail on the same tracepoints? Have you checkout the
> latest code?.
>
> I do know it fails on some of the KVM tracerpoints since the formatting
> they use is obnoxious.
>
>    

Isn't there a binary trace for this?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

