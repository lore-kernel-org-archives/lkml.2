Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2HTPre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:47:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HTPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <502C7F24.6020900@intel.com>
References: <5028F12C.7080405@intel.com>
	<20120815161911.GA14534@srcf.ucam.org>
	<502C7F24.6020900@intel.com>
Date: Mon, 20 Aug 2012 17:47:29 +0200
Message-ID: <CAKfTPtA98e8GYGwaj4k9y_-4h3e3UOguqJmdkqF0v3Y+5tPRpw@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2012 07:03, Alex Shi <alex.shi@intel.com> wrote:
> On 08/16/2012 12:19 AM, Matthew Garrett wrote:
>
>> On Mon, Aug 13, 2012 at 08:21:00PM +0800, Alex Shi wrote:
>>
>>> power aware scheduling), this proposal will adopt the
>>> sched_balance_policy concept and use 2 kind of policy: performance, power.
>>
>> Are there workloads in which "power" might provide more performance than
>> "performance"? If so, don't use these terms.
>>
>
>
> Power scheme should no chance has better performance in design.

A side effect of packing small tasks on one core is that you always
use the core with the lowest C-state which will minimize the wake up
latency so you can sometime get better results than performance mode
which will try to use a other core in another cluster which will take
more time to wake up that waiting for the end of the current task.

Vincent
