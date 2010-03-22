Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0CVAQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:16:53 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:46386 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0CVAQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:16:52 -0400
Message-ID: <4BA6B6F0.9080201@codemonkey.ws>
Date: Sun, 21 Mar 2010 19:16:48 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu>
In-Reply-To: <20100321215455.GB13219@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 04:54 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/21/2010 10:55 PM, Ingo Molnar wrote:
>>      
>>> Of course you could say the following:
>>>
>>>    ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
>>>      able to add this to the v2.6.35 kernel queue anymore as the ongoing
>>>      usability work already takes up all of the project's maintainer and
>>>      testing bandwidth. If you want the feature to be merged sooner than that
>>>      then please help us cut down on the TODO and BUGS list that can be found
>>>      at XYZ. There's quite a few low hanging fruits there. '
>>>        
>> That would be shooting at my own foot as well as the contributor's since I
>> badly want that RCU stuff, and while a GUI would be nice, that itch isn't on
>> my back.
>>      
> I think this sums up the root cause of all the problems i see with KVM pretty
> well.
>    

A good maintainer has to strike a balance between asking more of people 
than what they initially volunteer and getting people to implement the 
less fun things that are nonetheless required.  The kernel can take this 
to an extreme because at the end of the day, it's the only game in town 
and there is an unending number of potential volunteers.  Most other 
projects are not quite as fortunate.

When someone submits a patch set to QEMU implementing a new network 
backend for raw sockets, we can push back about how it fits into the 
entire stack wrt security, usability, etc.  Ultimately, we can arrive at 
a different, more user friendly solution (networking helpers) and along 
with some time investment on my part, we can create a much nicer, more 
user friendly solution.  Still command line based though.

Responding to such a patch set with, replace the SDL front end with a 
GTK one that lets you graphically configure networking, is not 
reasonable and the result would be one less QEMU contributor in the long 
run.

Overtime, we can, and are, pushing people to focus more on usability.  
But that doesn't get you a first class GTK GUI overnight.  The only way 
you're going to get that is by having a contributor be specifically 
interesting in building such a thing.

We simply haven't had that in the past 5 years that I've been involved 
in the project.  If someone stepped up to build this, I'd certainly 
support it in every way possible and there are probably some steps we 
could take to even further encourage this.

Regards,

Anthony Liguori

