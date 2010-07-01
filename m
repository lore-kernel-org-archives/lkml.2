Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0GAJ6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:58:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43635 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab0GAJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:58:30 -0400
Date: Thu, 1 Jul 2010 11:58:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv7 2.6.35-rc3-tip 0/11]  Uprobes Patches:
Message-ID: <20100701095815.GA26227@elte.hu>
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6>
 <20100701050216.GI23231@linux.vnet.ibm.com>
 <20100701081942.GA19826@elte.hu>
 <4C2C5D41.40807@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C5D41.40807@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0116]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> > - Plus the security model is an open question as well. Right now it's
> >   root-only, but it would make sense to allow users to insert probes into 
> >   their own apps. This brings up the next point:
> 
> Hmm, put a probe in user-space(by owner) may be good. But
> inside the kernel, there are more sensitive informations...

Yeah, clearly. Nevertheless this should not limit user-space probes.

	Ingo
