Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2DTJis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:38:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:43111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2DTJir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:38:47 -0400
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
In-Reply-To: <1334812653.14538.29.camel@ymzhang.sh.intel.com>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
	 <1334812653.14538.29.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 11:38:39 +0200
Message-ID: <1334914719.2463.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 13:17 +0800, Yanmin Zhang wrote:
> Although not checking the source codes of pstack (sorry, I'm busy in debugging
> many critical issues), I think pstack is based on ptrace interface, which means:
> 1) It need traps into system for many times to collect call frames of one
> task.
> 2) It need send signal to the ptraced process to stop it. Such behavior
> might have some impact if the ptraced process also processes many signals.

Yeah, but who cares.. its debugging stuff..

> 3) The data parsing to get symbols might not be split from data collection.
> I mean, it collects call frames of one process, then parses it; then collects the 2nd
> task's. If there are many processes, it couldn't collect the data just at the monitor
> time point. 

This is equally true for your silly patch.

