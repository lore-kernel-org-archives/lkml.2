Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1HXPI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:08:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:22633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1HXPI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:08:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="41750692"
Message-ID: <4E5513FA.6060904@linux.intel.com>
Date: Wed, 24 Aug 2011 08:08:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steevven1 <steevven1@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug Report for Linux Kernel 3.x
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com> <20110824001137.GA23979@somewhere> <CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com> <20110824135852.GE23979@somewhere>
In-Reply-To: <20110824135852.GE23979@somewhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/2011 6:58 AM, Frederic Weisbecker wrote:
> (Please don't top-post)
>
> On Tue, Aug 23, 2011 at 08:21:50PM -0400, Steevven1 wrote:
>> QUICK NOTE - Thanks for replying directly to me as well as the mailing
>> list. I am NOT on that mailing list. Please continue to do this.
>>
>> That is correct about sparse irq. That was causing the first problem,
>> and solving that did in fact result in better power performance, but
>> it was apparently NOT the bulk of the problem.
>>
>> We still have no diagnosis at all for the apparently still-present
>> other (mystery) problem. Powertop now reports to me very low processor
>> wakeups (basically the same as the 2.6-series kernels), which
>> indicates to me that the problem is PROBABLY not related to processor
>> wakeups. I am by no means an expert. The top wakeup-causers with the
>> modified 3.0 kernel (no sparse irq) and an idle system are "[iwlagn]
>> <interrupt>" (wifi), "[i915]<interrupt>" (I don't know what this is),
>> and "[kernel scheduler] Load balancing tick"
>>
>> P-states/frequencies are handled about the same as with the 2.6
>> kernels, so I don't see a problem there either.
>>
>> What else can I check? It seems like powertop is telling me nothing
>> about this mystery power drain.
> Well, if powertop has nothing to tell about that, I have no clue where
> to go. I'm adding more people in Cc in the hope they can be more
> helpful.
>


make sure to use powertop 1.98

