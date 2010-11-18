Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0KRJfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:35:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47743 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab0KRJfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:35:11 -0500
Date: Thu, 18 Nov 2010 10:34:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: jean.pihet@newoldbits.com, arjan@linux.intel.com, rjw@sisk.pl
Subject: Re: [PATCH 3/3] PERF(userspace): Adjust perf timechart to the new
 power events
Message-ID: <20101118093446.GB28467@elte.hu>
References: <1290072314-31155-1-git-send-email-trenn@suse.de>
 <1290072314-31155-4-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290072314-31155-4-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> Recent changes:
>    - Adjust state/cpuid to u32 as done in the kernel
> 
> The transition was rather smooth, only part I had to fiddle
> some time was the check whether a tracepoint/event is
> supported by the running kernel.

Hm, there's no Ack here from Arjan.

Timechart still works fine with the other two patches, right?

	Ingo
