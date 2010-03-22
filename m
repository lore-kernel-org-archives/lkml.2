Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0CVUUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:20:00 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:45646 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800Ab0CVUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:19:59 -0400
Message-ID: <4BA7D0E3.4080309@nagafix.co.uk>
Date: Tue, 23 Mar 2010 03:19:47 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander Graf <agraf@suse.de>, "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <4BA7C1D7.5070208@codemonkey.ws> <20100322193100.GB28709@redhat.com> <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de> <20100322195403.GC3306@elte.hu>
In-Reply-To: <20100322195403.GC3306@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 02:54 AM, Ingo Molnar wrote:
> * Alexander Graf<agraf@suse.de>  wrote
>> Yes. I think the point was that every layer in between brings potential
>> slowdown and loss of features.
>>      
> Exactly. The more 'fragmented' a project is into sub-projects, without a
> single, unified, functional reference implementation in the center of it, the
> longer it takes to fix 'unsexy' problems like trivial usability bugs.
>
> Furthermore, another negative effect is that many times features are
> implemented not in their technically best way, but in a way to keep them local
> to the project that originates them. This is done to keep deployment latencies
> and general contribution overhead down to a minimum. The moment you have to
> work with yet another project, the overhead adds up.
>
> So developers rather go for the quicker (yet inferior) hack within the
> sub-project they have best access to.
>
> Tell me this isnt happening in this space ;-)
>    
Integration is hard, requires a wider set of technical skills and 
getting good test coverage becomes more difficult.
But I agree that it is worth the effort, kvm could reap large rewards 
from putting a greater emphasis on integration (ala vbox) - no matter 
how it is achieved (cowardly not taking sides on implementation 
decisions like repository locations).

Antoine

> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

