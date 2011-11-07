Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1KGSHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:07:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60923 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab1KGSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:07:52 -0500
Message-ID: <1320689161.5809.1.camel@work-vm>
Subject: Re: [patch] x86, tsc: skip TSC synchronization checks for
 tsc=reliable
From: john stultz <johnstul@us.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 07 Nov 2011 10:06:01 -0800
In-Reply-To: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
References: <1320446537.15071.14.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110718-7282-0000-0000-0000037AAEFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 15:42 -0700, Suresh Siddha wrote:
> tsc=reliable boot parameter is supposed to skip all the TSC stablility
> checks during boot time.
> 
> On a 8-socket system where we want to run an experiment with the
> "tsc=reliable" boot option, TSC synchronization checks are not
> getting skipped and marking the TSC as not stable.
> 
> Check for tsc_clocksource_reliable (which is set via tsc=reliable or
> for platforms supporting synthetic TSC_RELIABLE feature bit etc)
> and when set, skip the TSC synchronization tests during boot.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Looks like a nice cleanup of the tsc=reliable semantics.

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john


