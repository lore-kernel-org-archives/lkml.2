Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1AQQle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:41:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62199 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1AQQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:41:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fMMpFP8kRsk1gB6W0WQmHHB1oAYBNqDJdxllhzbxypm8HAAU0ysacAqBJuL13MhL9r
         KW5Pw5l1skOEYu6mvn7+3/r3Qx8jDnLfcNj48HrrdeUXaDD3CiBfbFq4ebX5vvTxt1CA
         GHz1C4Kc5VKJ3D/3JP69xtVxI2J4ulSbamNrU=
Date: Mon, 17 Jan 2011 17:41:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 00/28] Removal of trace event semicolons
Message-ID: <20110117164059.GC1778@nowhere>
References: <20110109215927.633266833@efficios.com>
 <20110115234440.GC1768@nowhere>
 <20110117011916.GB6668@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117011916.GB6668@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 08:19:16PM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Sun, Jan 09, 2011 at 04:59:27PM -0500, Mathieu Desnoyers wrote:
> > > Hi,
> > > 
> > > I am hereby proposing the removal of trailing semicolons within the trace event
> > > headers.
> > > 
> > > Please refer to "patch 01: TRACE_EVENT: gradual semicolon removal" for
> > > explanation of this change. This patchset is based on the 2.6.37 kernel.
> > > 
> > > Feedback is welcome,
> > > 
> > > Thanks,
> > > 
> > > Mathieu
> > 
> > 
> > So, it seems there is no issue in spreading the whole into
> > each relevant trees?
> 
> Because there is a dependency on patch 01, I think it would be much less painful
> to bring in the whole patchset through the tracing tree rather than each
> targeted tree. Otherwise, we have to ensure that each tree has pulled the commit
> from the tracing tree before pulling the patches that depend on it.

Ok.
 
> And it only really touches the include/trace/ header files, so it's not as if it
> touched any specific subsystem code.

Beware, there are many trace events all over the kernel, not only in include/trace
