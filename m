Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2EHQ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:26:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EHQ0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:26:17 -0400
Message-ID: <1336494356.8226.32.camel@twins>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Geoff Levand <geoff@infradead.org>,
        linaro-sched-sig@lists.linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 08 May 2012 18:25:56 +0200
In-Reply-To: <1336493768.8226.29.camel@twins>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
	 <1336490832.8226.5.camel@twins>
	 <alpine.DEB.2.00.1205081035550.27713@router.home>
	 <1336492081.8226.13.camel@twins>
	 <alpine.DEB.2.00.1205081054310.27713@router.home>
	 <1336493768.8226.29.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 18:16 +0200, Peter Zijlstra wrote:
> No, it simply doesn't (and cannot) know this.. well it could but I think
> its an NP-hard problem. The way its been solved is by means of explicit
> configuration using cpusets. 

Yeah, it looks like a combinatorics problem. Anyway, even if we could
solve that problem we'd still end up with the cpuset infrastructure.
Only auto-magically configured instead of manually.
