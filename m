Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2FEGxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:53:05 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58272 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2FEGxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:53:02 -0400
Message-ID: <4FCDA231.60102@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 11:37:45 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot secondary
 processors
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <20120601165113.GA18870@merkur.ravnborg.org> <4FC9424E.9060009@linux.vnet.ibm.com> <alpine.LFD.2.02.1206041228330.3086@ionos> <4FCCB31B.6060302@linux.vnet.ibm.com> <20120605051144.GA4064@zhy>
In-Reply-To: <20120605051144.GA4064@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060420-1396-0000-0000-000001587D5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 10:41 AM, Yong Zhang wrote:

> On Mon, Jun 04, 2012 at 06:37:39PM +0530, Srivatsa S. Bhat wrote:
>> On 06/04/2012 04:02 PM, Thomas Gleixner wrote:
>>>> However, I do want to emphasize that this isn't generic code. So how about
>>>> an "arch_" prefix instead? Something like:
>>>> arch_cpu_pre_starting(), arch_cpu_pre_online() and arch_cpu_post_online()?
>>>
>>> Yes, please.
>>
>>
>> Sure, queued up for v2. (Atm, figuring out how to deal with xen (patch 5). Once
>> that gets done, will post a v2.)
> 
> Since there is dependency on ipi_call_lock cleanup patches
> http://marc.info/?l=linux-kernel&m=133827595625509&w=2
> 
> So please feel free to include the patches into yours.
>


Sure, if that would help Thomas pick them up easily.

 
> And It will be better that Thomas could pick them up :)
> 


Yes :)

Regards,
Srivatsa S. Bhat

> 
>>
>>>
>>> Otherwise, thanks for that work!
>>
>>
>> We are glad that it helps :-)
>>
>>> From the first glance, it's not
>>> colliding much with the changes I have in the pipeline, but I will
>>> have a closer look.
>>>
>>
>>
>> Great! Thanks a lot for your time, Thomas!
>>  
>> Regards,
>> Srivatsa S. Bhat
>>


