Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0DMJPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:15:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0DMJPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:15:21 -0400
Date: Tue, 13 Apr 2010 11:14:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 00/10] perf-probe updates - data-structure
 support improvements, etc.
Message-ID: <20100413091451.GB31264@elte.hu>
References: <20100412171646.3790.64715.stgit@localhost6.localdomain6>
 <20100412174914.GD6750@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412174914.GD6750@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Mon, Apr 12, 2010 at 01:16:46PM -0400, Masami Hiramatsu escreveu:
> > Hi Ingo and Arnaldo,
> > 
> > Here are several updates of perf-probe. This series improves data 
> > structure accessing. In this version, I added 'removing x*()' patches.
> 
> Ingo, I'm ok with this series, do you want me to pull them or will you?

Sure, feel free to pull it - you are doing many other tools/perf/ changes 
which might interact.

	Ingo
