Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0KSQcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:32:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:59614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab0KSQcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:32:46 -0500
Message-ID: <4CE6A69F.4030008@kernel.org>
Date: Fri, 19 Nov 2010 17:32:31 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Kirill Korotaev <dev@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <20101104164401.GC10656@sundance.ccs.neu.edu>	<4CD3CE29.2010105@kernel.org>	<20101106053204.GB12449@count0.beaverton.ibm.com>	<20101106204008.GA31077@sundance.ccs.neu.edu>	<4CD5D99A.8000402@cs.columbia.edu>	<20101107184927.GF31077@sundance.ccs.neu.edu>	<4CD72150.9070705@cs.columbia.edu>	<4CE3C334.9080401@kernel.org>	<20101117153902.GA1155@hallyn.com>	<4CE3F8D1.10003@kernel.org>	<20101119041045.GC24031@hallyn.com>	<4CE683E1.6010500@kernel.org>	<04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com>	<4CE698C5.5060806@kernel.org>	<AANLkTikRHuaCpaROtty6X_Oe6JixzgcbVsxHxvtsu+UV@mail.gmail.com>	<4CE6A076.2020807@kernel.org>	<AANLkTikz++4_SvqU_Wvx5CjcpKJhPsD7q470swdqwn94@mail.gmail.com>	<4CE6A397.6010105@kernel.org> <AANLkTin7kd3crS+fTLLea5PhAii7B3dz=n7p7YtQ6d4g@mail.gmail.com>
In-Reply-To: <AANLkTin7kd3crS+fTLLea5PhAii7B3dz=n7p7YtQ6d4g@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Nov 2010 16:32:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 05:27 PM, Alexey Dobriyan wrote:
> On Fri, Nov 19, 2010 at 6:19 PM, Tejun Heo <tj@kernel.org> wrote:
>>> The paragon of absurdity is struct task_struct::did_exec .
>>
>> Yeah, then go and figure how to do that in a way which would be useful
>> for other purposes too instead of trying to shove the whole
>> checkpointer inside the kernel.  It sure would be harder but hey
>> that's the way it is.
> 
> System call for one bit? This is ridiculous.

Why not just a flag in proc entry?  It's a frigging single bit.

> Doing execve(2) for userspace C/R is ridicoulous too (and likely
> doesn't work).

Really, whatever.  Just keep doing what you're doing.  Hey, if it
makes you happy, it can't be too wrong.

-- 
tejun
