Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367Ab0JIRn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 13:43:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab0JIRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 13:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=I83/SmHxC8ien0ibnYvp+cCRYx0rPHkdbT5eJG3qm/lXVHkymCw9vpXslg/EYCPCXA
         JW5CB2+yg3Ahte1v8iAJBGeoZUSI0pvoUVAxs7+aMlxU0hA2bHmVipHc6SPIwhufPqUO
         M2WlS0hwn2LfES5UiO42I+cl2XBJ0+lvqPtEo=
MIME-Version: 1.0
In-Reply-To: <4B91A25E.5030707@am.sony.com>
References: <4B91A25E.5030707@am.sony.com>
Date: Sat, 9 Oct 2010 23:13:24 +0530
X-Google-Sender-Auth: wZ_g1JJ03pCI4JeGJF8Gh3zdzKs
Message-ID: <AANLkTi=ULuo8upL9W2dCbn26G_i+moEO2EofBxy_fceU@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace - add ftrace function_graph support on ARM
From: Rabin Vincent <rabin@rab.in>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Sat, Mar 6, 2010 at 6:01 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> Add ftrace function-graph tracer support for ARM.
>
> This includes adding code in mcount to check for
> (and call) a registered function graph trace entry
> routine, and adding code to support a return
> trampoline, to catch the function exit.
>
> IRQENTRY_TEXT was added to vmlinux.lds.S (to eliminate
> a compiler error on kernel/trace/trace_functions_graph.c),
> although no routines were marked as __irq_entry.
>
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

What happened to this?  Do you intend to post a new version of these
patches?  If not, I'd like to post a series which updates this to
current kernels and also adds support for the graph tracer + dynamic
ftrace combo on ARM based on the recent ARM dynamic ftrace support.

Rabin
