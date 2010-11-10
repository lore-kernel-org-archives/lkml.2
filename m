Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0KJJMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:12:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab0KJJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:12:40 -0500
Date: Wed, 10 Nov 2010 10:12:17 +0100
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
Subject: Re: [PATCH 2/2] perf bench: add x86-64 specific benchmarks to perf
 bench mem memcpy
Message-ID: <20101110091217.GD8370@elte.hu>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20101030192357.GC26503@elte.hu>
 <4CCE51E6.7060908@dcl.info.waseda.ac.jp>
 <20101101090251.GA28039@elte.hu>
 <4CD43975.1000300@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD43975.1000300@dcl.info.waseda.ac.jp>
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

> > An even better solution would be to output _both_ results by default, so that 
> > people can see both characteristics at a glance?
> 
> Outputting both result of prefaulted and non prefaulted will be useful, but this 
> might be not good for using from scripts. So I'll implement --prefault option 
> first. If there is request for outputting both, I'll consider to modify default 
> output.

Ok - it should definitely be easily scriptable. The default can be have both flags 
enabled and both results written to the output.

People will try 'perf bench x86' to see performance at a glance - so printing all 
the tests we have is a good idea.

Thanks,

	Ingo
