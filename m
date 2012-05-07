Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2EGMvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:51:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2EGMvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:51:17 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GBCmzka__k8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=9-HNvSgTAAAA:8 a=paAwSOw7zTvBlMFaMyUA:9 a=PUjeQqilurYA:10 a=ToN9MrSwoHAA:10 a=sJde23VzLGUA:10 a=qR00BvEwNZwA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336395075.14207.120.camel@gandalf.stny.rr.com>
Subject: Re: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved
 text (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Mon, 07 May 2012 08:51:15 -0400
In-Reply-To: <1336394682.14207.119.camel@gandalf.stny.rr.com>
References: <20120502192418.024103772@goodmis.org>
	 <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>
	 <1336002032.14207.52.camel@gandalf.stny.rr.com>
	 <4FA7B410.1000804@hitachi.com> <4FA7B91F.7070608@hitachi.com>
	 <1336394682.14207.119.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 08:44 -0400, Steven Rostedt wrote:
> On Mon, 2012-05-07 at 20:59 +0900, Masami Hiramatsu wrote:
> 
> > BTW, Steven, is this series already put on some git repository?
> > I'd like to pull it to work on that.
> 
> It's currently only on my local machines because I rebase it a lot. I
> can push it out for you to play with, but it is not in its final form
> (yet) and may be rebased once again. Thus, don't rely on it ;-)
> 

I just pushed this branch to my repo:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

tip/perf/next

-- Steve


