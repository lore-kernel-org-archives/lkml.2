Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2EGMn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:43:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2EGMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:43:26 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=GBCmzka__k8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=sKZKgP6f74Huiqa1P1MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336394603.14207.117.camel@gandalf.stny.rr.com>
Subject: Re: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved
 text (but move it)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Date: Mon, 07 May 2012 08:43:23 -0400
In-Reply-To: <4FA7B410.1000804@hitachi.com>
References: <20120502192418.024103772@goodmis.org>
	  <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>
	 <1336002032.14207.52.camel@gandalf.stny.rr.com>
	 <4FA7B410.1000804@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 20:37 +0900, Masami Hiramatsu wrote:

> By the way, there is another way to do that transparently which
> we add a "real_addr" member to struct kprobes and put the real
> probed address to the member (without changing kp->addr). This
> will keep API compatibility.

I like this a lot. Perhaps we don't need a flag at all, and just use
these two addrs instead?

-- Steve


