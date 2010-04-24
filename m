Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0DXC5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:57:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33602 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0DXC5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:57:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5961"; a="39596188"
Message-ID: <4BD25E1A.50505@codeaurora.org>
Date: Fri, 23 Apr 2010 19:57:30 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
References: <4BCFC3D0.5080904@codeaurora.org>	<4BD0D9E5.3020606@codeaurora.org>	<20100423184042.GA16190@Krystal> <20100423122259.49e0416a@infradead.org>
In-Reply-To: <20100423122259.49e0416a@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> so in reality, all hardware that does coordination between cores/etc
> like this also has a tsc that is invariant of the actual P state.
> If there are exceptions, those have a problem, but I can't think of any
> right now.
> Once the TSC is invariant of P state, udelay() is fine, since that goes
> of the tsc, not of some delay loop kind of thing....

I assume you are talking specifically about x86. I want x86 to be 
correct, but also want ARM to be correct. So, at this point I might as 
well try to put in an arch independent fix.

Thanks,
Saravana
