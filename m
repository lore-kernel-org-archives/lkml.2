Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0CVHN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0CVHNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:13:25 -0400
Message-ID: <4BA7187E.3050405@redhat.com>
Date: Mon, 22 Mar 2010 09:13:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
References: <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu>
In-Reply-To: <20100321215455.GB13219@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 11:54 PM, Ingo Molnar wrote:
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

I think we agree at last.  Neither I nor my employer are interested in 
running qemu as a desktop-on-desktop tool, therefore I don't invest any 
effort in that direction, or require it from volunteers.

If you think a good GUI is so badly needed, either write one yourself, 
or convince someone else to do it.

(btw, why are you interested in desktop-on-desktop?  one use case is 
developers, which don't really need fancy GUIs; a second is people who 
test out distributions, but that doesn't seem to be a huge population; 
and a third is people running Windows for some application that doesn't 
run on Linux - hopefully a small catergory as well.  Seems to be quite a 
small target audience, compared to, say, video editing)

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

