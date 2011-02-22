Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1BVSXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:23:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab1BVSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZPlzq/wo10ItobWBxkkRHUognz7rkgn70TcMotg7gcn6l9M9bZmYt08uVnoGyhUQcn
         M7i8lBojTWN39VunCnebaAI9s2l02yElk6vfdCfvsdZArbONunAYgZUpb+TQtn7MpH0J
         X3Y75tDUvtaXwRodjnMNX/iYDOXxAQiH7vZQc=
Date: Tue, 22 Feb 2011 19:22:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
Message-ID: <20110222182206.GB1799@nowhere>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <4D63D685.2010401@dcl.info.waseda.ac.jp>
 <1298389415.2217.243.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298389415.2217.243.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 04:43:35PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-02-23 at 00:30 +0900, Hitoshi Mitake wrote:
> > How do you think about it?
> 
> Most of the lock code (esp the spinlock stuff) is already way over the
> threshold of sanity, adding to that for some dubious reasons doesn't
> seem like a good idea.
> 
> I'm still not at all sure why people want all this lock tracing.

Right, well I can imagine many usecases that could make lock
tracing bring more value than what lockstat already provides,
through a tool like perf lock if we enhance it.

We should probably first focus on developing the tooling side
and make it useful enough that optimizations in the kernel
side become desirable.
