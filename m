Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0JUKMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:12:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:42589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0JUKMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:12:18 -0400
Subject: Re: Ftrace: can trace kthread?
From: Peter Zijlstra <peterz@infradead.org>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1287651542.2237.17.camel@myhost>
References: <1287647732.2237.7.camel@myhost>
	 <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	 <1287649283.2237.8.camel@myhost>
	 <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
	 <1287650668.2237.12.camel@myhost>
	 <AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
	 <1287651542.2237.17.camel@myhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 12:12:07 +0200
Message-ID: <1287655927.3488.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 16:59 +0800, Figo.zhang wrote:
> > I just
> > echo  0 > tracing_enabled
> > echo function > current_tracer
> > echo 374(pid of flush) > set_ftrace_pid
> > echo 1 > tracing_enabled
> > wait some time
> > echo 0 > tracing_enabled
> > cat trace
> > 
> > So I think this answer your question "could kthread be traced?"
> 
> i do it the same of you.

> but i canot trace nothing. 

Your initial attempt had:

        echo kswapd > /sys/kernel/debug/tracing/set_graph_function

have you reset that state?
