Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0CROx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:53:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60690 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0CROx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:53:26 -0400
Message-ID: <4BA23E61.4080003@codemonkey.ws>
Date: Thu, 18 Mar 2010 09:53:21 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu>
In-Reply-To: <20100318114821.GB13168@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 06:48 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/18/2010 12:50 PM, Ingo Molnar wrote:
>>      
>>> * Avi Kivity<avi@redhat.com>   wrote:
>>>
>>>        
>>>>> The moment any change (be it as trivial as fixing a GUI detail or as
>>>>> complex as a new feature) involves two or more packages, development speed
>>>>> slows down to a crawl - while the complexity of the change might be very
>>>>> low!
>>>>>            
>>>> Why is that?
>>>>          
>>> It's very simple: because the contribution latencies and overhead compound,
>>> almost inevitably.
>>>        
>> It's not inevitable, if the projects are badly run, you'll have high
>> latencies, but projects don't have to be badly run.
>>      
> So the 64K dollar question is, why does Qemu still suck?
>    

Why does Linux AIO still suck?  Why do we not have a proper interface in 
userspace for doing asynchronous file system operations?

Why don't we have an interface in userspace to do zero-copy transmit and 
receive of raw network packets?

The lack of a decent userspace API for asynchronous file system 
operations is a huge usability problem for us.  Take a look at the 
complexity of our -drive option.  It's all because the kernel gives us 
sucky interfaces.

Regards,

Anthony Liguori
