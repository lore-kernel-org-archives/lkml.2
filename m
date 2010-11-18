Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0KRH6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:58:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58445 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0KRH6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:58:33 -0500
Date: Thu, 18 Nov 2010 08:58:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf bench: print both of prefaulted and no prefaulted
 results
Message-ID: <20101118075816.GG32621@elte.hu>
References: <4CDD56E3.5030303@dcl.info.waseda.ac.jp>
 <1289574158-6959-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289574158-6959-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
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


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> After applying this patch, perf bench mem memcpy prints
> both of prefualted and without prefaulted score of memcpy().
> 
> New options --no-prefault and --only-prefault are added
> for printing single result, mainly for scripting usage.

Ok. Mind resending the whole series once all review feedback has been incorporated?

Thanks,

	Ingo
