Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2LMCxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:53:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:10411 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab2LMCxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:53:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,270,1355126400"; 
   d="scan'208";a="230828089"
Message-ID: <50C942AE.6010102@intel.com>
Date: Thu, 13 Dec 2012 10:51:26 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Alex Shi <lkml.alex@gmail.com>, Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic> <50C75935.1040004@linux.intel.com> <20121211161320.GA28827@liondog.tnic> <50C76208.107@linux.intel.com> <CAHLCerPy2+-t0mAwn3nEAd2CRMmyqCLVTO3j2zua1P4uDE1BPA@mail.gmail.com> <CAGjg+kHTvQe4NBTf41oSanZ9WBvFHsRPFqT4MdW9Sft=pOd5HA@mail.gmail.com> <CAKfTPtC+=-zvQ=NyVyDto76SfJY=90e4mrkJ0DGH-_PVpBg3EQ@mail.gmail.com>
In-Reply-To: <CAKfTPtC+=-zvQ=NyVyDto76SfJY=90e4mrkJ0DGH-_PVpBg3EQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 10:21 PM, Vincent Guittot wrote:
>>> >> If Linux is to continue to work efficiently on heterogeneous
>>> >> multi-processing platforms, it needs to provide scheduling mechanisms
>>> >> that can be exploited as per the demands of the HW architecture.
>> >
>> > Linus definitely disagree such ideas. :) So, need to summaries the
>> > logical beyond all hardware.
>> >
>>> >> example is the "small task packing (and spreading)" for which Vincent
>>> >> Guittot has posted a patchset[1] earlier and so has Alex now.
>> >
>> > Sure. I just thought my patchset should handled the 'small task
>> > packing' scenario. Could you guy like to have a try?
> Hi Alex,
> 
> Yes, I will do a try with your patchset when i will have some spare time

Thanks Vincent! the balance and powersaving policy should have effect.
