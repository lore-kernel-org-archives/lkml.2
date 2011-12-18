Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1LRIGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:06:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1LRIGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:06:42 -0500
Date: Sun, 18 Dec 2011 09:04:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, suresh.b.siddha@intel.com,
        eranian@google.com, brgerst@gmail.com, robert.richter@amd.com,
        Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bebl@mageta.org,
        Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111218080443.GB4144@elte.hu>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> From: Benjamin Block <benjamin.block@amd.com>
> 
> Implements a basic integration of LWP into perf. Permits a way 
> to create a perf-event that will be backed by LWP. The PMU 
> creates the required structures and userspace-memories. The 
> PMU also collects the samples from the ring-buffer, but as 
> there is currently no interrupt- and overflow-implementation, 
> they are not reported (TODO).

Ok, this is a step in the right direction - once the threshold 
IRQ flow control mechanism is implemented we are looking at 
something that might be mergeable. Any ETA on those bits?

Thanks,

	Ingo
