Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1BXSqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:46:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1BXSqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:46:52 -0500
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 19:46:37 +0100
Message-ID: <1298573197.2428.457.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 18:33 +0100, Vincent Guittot wrote:

> The goal is to measure the latency of each part (kernel, architecture)
> and also to trace the cpu hotplug activity with other power events. I
> have tested these traces events on an arm platform.

> this patch adds new events for cpu hotplug tracing
>  * plug/unplug sequence
>  * core and architecture latency measurements

Aside of the points tglx made, I do have to ask _WHY_!?

Anybody who is interested in the latency of cpu hotplug is deluding
himself, also cpu hotplug is _NOT_ a power management feature, so the
rest of your justification just disappeared as well.


