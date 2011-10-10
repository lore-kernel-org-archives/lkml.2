Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1JJTLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:11:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1JJTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:11:20 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=kycaZ6zZ8KAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=M-bkJVFu36DEJtTAY-oA:9 a=EO-8O_nvXX40qb6O1S8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/4] [BUGFIX] ftrace/kprobes: Fix not to delete probes
 if in use
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>
Date: Mon, 10 Oct 2011 15:11:18 -0400
In-Reply-To: <4E92FDE3.8050301@hitachi.com>
References: <20111004104438.14591.6553.stgit@fedora15>
	 <1318050006.4729.103.camel@gandalf.stny.rr.com>
	 <4E92FDE3.8050301@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318273879.7904.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 23:14 +0900, Masami Hiramatsu wrote:

> > Does this exist in previous kernels? If so, I'll also add the stable tag
> > to it.
> 
> I guess so, since the perf's tracepoint handler locks target module
> while recording, it is required for perf not to remove undergo events.

I was able to trigger this bug in 2.6.39 as well. I'll add the stable
tag to it and post it.

Thanks!

-- Steve


