Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0CTEqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 00:46:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60515 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0CTEqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 00:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYGDxsPUP1PDN14IZRJnnK/ovxaWBnAbof1Sunan27YqTTkVvaMOLgGEunIjZIaflE
         qEaMbECr9AiMMzFtckRwBWk8gpl7PhinQ/dR11HBrqPq1be1XZRJKpDQ+ACrzj0hjCgI
         Qqn97gqJxKdcjHGgQZvrgBQS/2+YCr9s9X/2c=
Date: Sat, 20 Mar 2010 05:46:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100320044649.GL5085@nowhere>
References: <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere> <20100319013658.GB28456@Krystal> <20100319022659.GC22095@nowhere> <20100319024042.GB28941@Krystal> <20100319030611.GE22095@nowhere> <20100319125600.GA12211@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319125600.GA12211@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 08:56:00AM -0400, Mathieu Desnoyers wrote:
> > Sure. My doubt is: currently with the upstream version, does the
> > compiler tend to load the parameters to the stack before the branch is
> > checked? Or is this a magic that jmp labels bring for whatever reason?
> 
> Even without the static jump patching, the compiler takes care of putting the
> stack setup after the branch is checked. That worked with a standard test on a
> variable, with immediate values and should still work with asm gotos.


Ok.


 
> I already did some presentations around these question. You can refer to my OLS
> 2008 slides, where I proposed static jump patching (ancestor of the asm gotos,
> where I did the liveness analysis myself in the back of the compiler; good
> enough for a prototype ;) ). Slide 11 discusses the branch vs stack setup
> question:
> 
> http://lttng.org/files/slides/desnoyers-talk-ols2008.pdf
> 
> Even more in Sections 8.1, 8.2 and 8.3 of my thesis:
> 
> http://lttng.org/files/thesis/desnoyers-dissertation-2009-12-v27.pdf
> 
> 8.1 Kernel Markers
> 8.2 Tracepoints
> 8.3 Immediate Values


Cool. I was already keeping your thesis on hand anyway :)

Thanks.

