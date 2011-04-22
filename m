Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1DVISu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:18:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab1DVISq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:18:46 -0400
Date: Fri, 22 Apr 2011 10:18:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
Message-ID: <20110422081838.GA24011@elte.hu>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
 <1303398203-2918-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303398203-2918-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Due to restriction and specifics of Netburst PMU we need
> a separated event for NMI watchdog. Note that on all other
> than P4 PMU cpus this event is a simple alias for PERF_COUNT_HW_CPU_CYCLES.
> 
> This event is only used by x86 for now so no other archs involved.

hm, there's no explanation exactly why this is needed and what the alternatives 
are.

This sentence:

> +  /* we use that named non-sleeping calls */

does not parse for me.

Thanks,

	Ingo
