Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1CUNNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:13:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59160 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1CUNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:13:17 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=d6KjmF4z1lEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TNQApoaQx8nLwWLAopQA:9 a=Ag3VQhgm64_9YTiNb0Q451UmgM8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Steven Rostedt <rostedt@goodmis.org>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Julia Lawall <julia@diku.dk>,
        Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110320154827.7ba3358b@varda>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	 <20110317211548.646b04d2@tpl.lwn.net>
	 <1300419170.16880.956.camel@gandalf.stny.rr.com>
	 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
	 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
	 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
	 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
	 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
	 <20110320105412.GA11266@elte.hu>  <20110320154827.7ba3358b@varda>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 21 Mar 2011 09:13:12 -0400
Message-ID: <1300713192.16880.5789.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-20 at 15:48 +0100, Alejandro Riveira Fernández wrote:
> El Sun, 20 Mar 2011 11:54:12 +0100
> Ingo Molnar <mingo@elte.hu> escribió:
> 

>  But a perl interpreter is not shipped with the kernel, is it? neither a
>  posix shell or a python interpreter ...
>  The scripts are already shipped with the kernel, the "interpreter" have
>  to be installed in the dev machine like you have to install perl, make,
>  gcc, etc

We don't ship gcc either. Note, there are some cases where you need a
perl interpreter to build the kernel.

-- Steve


