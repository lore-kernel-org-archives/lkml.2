Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2E3HU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:20:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59976 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2E3HU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:20:26 -0400
Date: Wed, 30 May 2012 09:20:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Chen <hi3766691@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120530072019.GD2587@gmail.com>
References: <1337084609.27020.156.camel@laptop>
 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337468148.573.139.camel@twins>
 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
 <CANQmPXjiqtDE_4ZmNrtrb9qjB=gyv=NiPr3pdaHFirSs0T3ptQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANQmPXjiqtDE_4ZmNrtrb9qjB=gyv=NiPr3pdaHFirSs0T3ptQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(restored the Cc:s)

* Chen <hi3766691@gmail.com> wrote:

> Oh, Just count the size of the scheduler code yourself, 
> actually 400 - 500k. core.c + fair.c + rt.c + idle_task.c + 
> everything

Only binary code is counted in bytes, source code is counted in 
lines.

20 KLOC for a full-featured CPU scheduler that does everything 
from simple UP scheduling to thousands of CPUs NUMA scheduling, 
cgroups, real-time and more, is entirely reasonable.

As a comparison the VM is 80+ KLOCS, arch/x86/ is 260+ KLOCs, 
networking is 720+ KLOCS and the FS subsystem is over 1 million 
lines of code.

The scheduler is in fact one of the smaller subsystems.

Thanks,

	Ingo
