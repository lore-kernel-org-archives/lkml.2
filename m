Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1IMGOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 02:14:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64182 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1IMGOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 02:14:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,372,1312182000"; 
   d="scan'208";a="52373744"
Message-ID: <4E6EF4AE.4030503@intel.com>
Date: Tue, 13 Sep 2011 14:14:06 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is the difference between percpu_xxx and this_cpu_xxx?
References: <4E6EDBFB.4010705@intel.com> <1315894267.2556.21.camel@edumazet-laptop>
In-Reply-To: <1315894267.2556.21.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric,

On 09/13/2011 02:11 PM, Eric Dumazet wrote:
> Le mardi 13 septembre 2011 à 12:28 +0800, Huang Ying a écrit :
>> Hi,
>>
>> If my understanding was correct, from the kernel source code, it appears
>> that percpu_xxx and this_cpu_xxx have the same semantics and
>> implementation in effect, haven’t them?
>>
>> If so, why do we need two API for the same thing?
> 
> History mostly, and transition.
> 
> percpu_inc() was an x86 only thing
> 
> __get_cpu_var(var)++ -> percpu_inc(var) -> this_cpu_inc(var)

Thanks for clarification.  Is there someone working on the transition?
Is that possible to translate most percpu_xxx to this_cpu_xxx blindly?

Best Regards,
Huang Ying
