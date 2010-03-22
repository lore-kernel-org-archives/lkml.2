Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0CVMhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab0CVMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:37:23 -0400
Message-ID: <4BA76443.7030104@redhat.com>
Date: Mon, 22 Mar 2010 14:36:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu>
In-Reply-To: <20100322114824.GF3483@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 01:48 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> My 10+ years experience with kernel instrumentation solutions is that
>>> kernel-driven, self-sufficient, robust, trustable, well-enumerated sources
>>> of information work far better in practice.
>>>        
>> What about line number information?  And the source?  Into the kernel with
>> them as well?
>>      
> Sigh. Please read the _very first_ suggestion i made, which solves all that. I
> rarely go into discussions without suggesting technical solutions - i'm not
> interested in flaming, i'm interested in real solutions.
>
> Here it is, repeated for the Nth time:
>
> Allow a guest to (optionally) integrate its VFS namespace with the host side
> as well. An example scheme would be:
>
>     /guests/Fedora-G1/
>    

[...]

You're missing something.  This sub-thread is about someone launching a 
kernel with 'qemu -kernel', the kernel lives outside the guest disk 
image, they don't want a custom initrd because it's hard to make.

-- 
error compiling committee.c: too many arguments to function

