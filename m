Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1I1OXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:23:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56080 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1I1OXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:23:21 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=v1jNb7L17ooA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=R6Ph2Kqlq8VnvbJxTCsA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Date: Wed, 28 Sep 2011 10:23:20 -0400
In-Reply-To: <20110928141754.GT18553@somewhere>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
	 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
	 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
	 <1317044192.26514.1.camel@gandalf.stny.rr.com>
	 <20110926145606.GA8886@jolsa.brq.redhat.com>
	 <20110928135525.GS18553@somewhere>
	 <1317218589.4588.4.camel@gandalf.stny.rr.com>
	 <20110928141754.GT18553@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317219800.4588.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 16:17 +0200, Frederic Weisbecker wrote:
> > > 
> > > But it seems Steve's patches are not completely uncontroversial because
> > > of some crazy disagreements on where the libparsevent.so should lay (tools generic
> > > or tied to perf).
> > 
> > Which to me seems to be a silly road block, in which I never got a clear
> > answer for.
> 
> Yeah we need to sort that out with Ingo.

And include Arnaldo, as he was the one that suggested to do what I did
that Ingo NACKd. And I consider Arnaldo the maintainer of the userspace
side of perf, so I will not step on his toes in what I do.

-- Steve


