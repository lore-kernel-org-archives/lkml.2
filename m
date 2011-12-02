Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1LBMIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:08:30 -0500
Received: from stinky.trash.net ([213.144.137.162]:34884 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab1LBMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:08:28 -0500
X-Greylist: delayed 689 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 07:08:28 EST
Message-ID: <4ED8BD00.4000500@trash.net>
Date: Fri, 02 Dec 2011 12:56:48 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
References: <1318237851.27949.190.camel@debian>	 <alpine.DEB.2.00.1110101026080.16264@router.home>	 <1318324774.27949.693.camel@debian>	 <alpine.DEB.2.00.1110110910480.3388@router.home>	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>	 <alpine.DEB.2.00.1110120910540.26610@router.home>	 <1318908091.23426.52.camel@debian>	 <alpine.DEB.2.00.1110180932330.687@router.home>	 <1319016218.23426.104.camel@debian>	 <alpine.DEB.2.00.1110191033480.24001@router.home>	 <1319078687.23426.146.camel@debian>	 <1319087281.8416.45.camel@edumazet-laptop>	 <1319095929.23426.180.camel@debian>	 <1319099893.3781.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <1321866051.30341.565.camel@debian> <1322793200.11530.33.camel@debian>
In-Reply-To: <1322793200.11530.33.camel@debian>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.2011 03:33, Alex,Shi wrote:
> On Mon, 2011-11-21 at 17:00 +0800, Alex,Shi wrote:
>> On Thu, 2011-10-20 at 16:38 +0800, Eric Dumazet wrote:
>>> Le jeudi 20 octobre 2011 à 15:32 +0800, Alex,Shi a écrit :
>>>> percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
>>>> for further code clean up.
>>>>
>>>> And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
>>>> performance since __this_cpu_xxx has no redundant preempt_disable()
>>>>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>> ---
>>>>  net/netfilter/xt_TEE.c |   12 ++++++------
>>>>  net/socket.c           |    4 ++--
>>>>  2 files changed, 8 insertions(+), 8 deletions(-)
>>>
>>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>>>
>>> Thanks !
>>
>> Anyone like to pick up this patch? or more comments for this? 
> 
> Kaber, David: 
> I appreciate for your any comments on this. Could you like do me a
> favor? 

No objections from me.
