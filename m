Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2FSMaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:30:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FSMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:30:17 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FNqztoQSzWUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=vqF6KEcjAAAA:8 a=jUg4Kj2VfCkoZYuS6VUA:9 a=PUjeQqilurYA:10 a=FeP6IhHVxj4A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340109015.25903.217.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 1/5] tools lib traceevent: Replace malloc_or_die to
 plain calloc in alloc_event()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 19 Jun 2012 08:30:15 -0400
In-Reply-To: <87r4tbhgqf.fsf@sejong.aot.lge.com>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
	 <1340027148.25903.90.camel@gandalf.stny.rr.com>
	 <20120618140625.GH2303@infradead.org> <87r4tbhgqf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 17:02 +0900, Namhyung Kim wrote:
> Hi, Arnaldo
> 
> On Mon, 18 Jun 2012 11:06:25 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jun 18, 2012 at 09:45:48AM -0400, Steven Rostedt escreveu:
> >> Arnaldo,
> >> 
> >> I've acked this series. Can you add my Acked-by tags on the patches that
> >> do not have it yet, and then pull it into your repo?
> >
> > Sure thing, I'll put it in my perf/core branch,
> >
> 
> As I said before [1], those patches are based on my libtraceevent/next
> branch which contains a couple of commits not merged into tip or your
> tree. They are my previous backport work, and Steve wanted to leave them
> out for 3.6 cycle [2].

As the merge window has closed, I was under the assumption that these
patches are for 3.6. That's what I wanted them queued up for.

-- Steve


