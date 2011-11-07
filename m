Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1KGTgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:36:41 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35526 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1KGTgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:36:40 -0500
Message-ID: <4EB83341.9080600@linux.vnet.ibm.com>
Date: Tue, 08 Nov 2011 01:06:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, tsc: skip TSC synchronization checks for tsc=reliable
References: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/05/2011 04:12 AM, Suresh Siddha wrote:
> tsc=reliable boot parameter is supposed to skip all the TSC stablility
> checks during boot time.
> 
> On a 8-socket system where we want to run an experiment with the
> "tsc=reliable" boot option, TSC synchronization checks are not
> getting skipped and marking the TSC as not stable.
>

I was facing this same problem some time back with some of my machines.

> Check for tsc_clocksource_reliable (which is set via tsc=reliable or
> for platforms supporting synthetic TSC_RELIABLE feature bit etc)
> and when set, skip the TSC synchronization tests during boot.
> 

This patch fixes the issue. Thanks for the fix!

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

