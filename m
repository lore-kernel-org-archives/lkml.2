Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab0LCOpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:45:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab0LCOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:45:01 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=YndEQwitm8YA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VwQbUJbxAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=Tty9oNO6AAAA:8 a=pGLkceISAAAA:8 a=bb4madVcwnGkgdAtjnAA:9 a=-28QVHXow4AWcWk9CQiO3FCD01IA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=LI9Vle30uBYA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip v5 6/8] x86: Introduce text_poke_smp_batch() for
 batch-code modifying
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jan Beulich <jbeulich@novell.com>
In-Reply-To: <20101203095422.2961.51217.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101203095325.2961.75137.stgit@ltc236.sdl.hitachi.co.jp>
	 <20101203095422.2961.51217.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 09:44:59 -0500
Message-ID: <1291387499.3228.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 18:54 +0900, Masami Hiramatsu wrote:
> Introduce text_poke_smp_batch(). This function modifies several
> text areas with one stop_machine() on SMP. Because calling
> stop_machine() is heavy task, it is better to aggregate text_poke
> requests.
> 
> Frederic, I've talked with Rusty about this interface, and
> he would not like to expand stop_machine() interface, since
> it is not for generic use.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Jan Beulich <jbeulich@novell.com>

Looks good,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Jason Baron <jbaron@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---


