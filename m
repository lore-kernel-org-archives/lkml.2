Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab0FJMGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:06:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab0FJMGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:06:30 -0400
Date: Thu, 10 Jun 2010 14:06:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
Message-ID: <20100610120608.GB16514@elte.hu>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
 <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
 <1276166813.2077.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276166813.2077.96.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0013]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Something like the below would work, the only 'problem' is that it grows
> hw_perf_event.

> @@ -531,6 +531,7 @@ struct hw_perf_event {
>  		struct { /* software */
>  			s64		remaining;
>  			struct hrtimer	hrtimer;
> +			int		stopped;

IMO that's ok.

	Ingo
