Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2CCLbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:31:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:30708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab2CCLbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:31:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="114107167"
Message-ID: <4F5200BB.5090505@intel.com>
Date: Sat, 03 Mar 2012 19:30:03 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
Subject: Re: change last level cache alignment on x86?
References: <1330590816.21053.1336.camel@debian> <1330673425.21053.1503.camel@debian> <20120302081208.GA24504@elte.hu> <4F50DC42.3090300@intel.com> <20120302152506.GA14487@elte.hu>
In-Reply-To: <20120302152506.GA14487@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 11:25 PM, Ingo Molnar wrote:
> * Alex Shi <alex.shi@intel.com> wrote:
>
>> So, with defconfig on x86_64, I saw much changes in System.map:
>> 	before patched			after patched
>>   ...
>>   000000000000b000 d tlb_vector_|  000000000000b000 d tlb_vector
>>   000000000000b080 d cpu_loops_p|  000000000000b040 d cpu_loops_
>>   ...
> Ok, mind sending a patch, changelogged, with a SOB?

Thanks a lot for review! A patch was sent to you.
> Thanks,
>
> 	Ingo

