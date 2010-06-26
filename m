Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0FZQWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 12:22:40 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49832 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0FZQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 12:22:39 -0400
Message-ID: <4C262949.3030804@linux.vnet.ibm.com>
Date: Sat, 26 Jun 2010 09:22:33 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
References: <20100624142804.431553874@chello.nl>
In-Reply-To: <20100624142804.431553874@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 07:28 AM, Peter Zijlstra wrote:
> These patches prepare the perf code for multiple pmus (no user
> interface yet, Lin Ming is working on that). These patches remove all
> weak functions and rework the struct pmu interface.
>
> The patches are boot tested on x86_64 and compile tested on: powerpc
> (!fsl, what config is that?), sparc and arm (sorry no SH compiler)
>
> On x86 perf stat and record with both software and hardware events still worked.
>
> I changed all (hardware) pmu implementations so there's a fair chance I messed
> something up, please have a look at it.
>
> If people agree with this, I'll continue with the per-pmu context stuff I
> talked about last time, which should get us the hardware write batching back.

Hi Peter,

These patches look like they are really taking us in the right 
direction.  Thanks for all your effort on this!

As for the "hardware write batching", can you describe a bit more about 
what you have in mind there?  I wonder if this might have something to 
do with accounting for PMU hardware which is slow to access, for 
example, via I2C via an internal bridge.

Cheers,

- Corey

