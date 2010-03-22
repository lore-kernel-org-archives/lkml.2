Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0CVSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0CVSCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:02:19 -0400
Message-ID: <4BA7B098.60205@redhat.com>
Date: Mon, 22 Mar 2010 20:02:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Frank Ch. Eigler" <fche@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu> <y0mmxy0wa1r.fsf@fche.csb> <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com> <20100322174328.GA26949@elte.hu>
In-Reply-To: <20100322174328.GA26949@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 07:43 PM, Ingo Molnar wrote:
>
>> It's kinda funny to see people argue that having an external repository is
>> not a problem and that it's not a big deal if building something from the
>> repository is slightly painful as long as it doesn't require a PhD when we
>> have _real world_ experience that it _does_ limit developer base in some
>> cases. Whether or not that applies to kvm remains to be seen but I've yet to
>> see a convincing argument why it doesn't.
>>      
> Yeah.
>
> Also, if in fact the claim that the 'repository does not matter' is true then
> it doesnt matter that it's hosted in tools/kvm/ either, right?
>    

Again, the second it's moved to tools/kvm/ we strip it off anything that 
kvm can't use.

> I.e. it's a win-win situation. Worst-case nothing happens beyond a Git URI
> change. Best-case the project is propelled to never seen heights due to
> contribution advantages not contemplated and not experienced by the KVM guys
> before ...
>    

You're exaggerating.  There were 773 commits into qemu.git (excluding 
qemu-kvm.git) in the past three months.  162 for the same period for 
tools/perf.  The pool is not that deep.

-- 
error compiling committee.c: too many arguments to function

