Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2A0LQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:16:11 -0500
Received: from ozlabs.org ([203.10.76.45]:35975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab2A0LQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:16:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
In-Reply-To: <20120126183946.GA14709@elte.hu>
References: <1326807145.17534.26.camel@gandalf.stny.rr.com> <20120118120711.GB14863@elte.hu> <1326909412.17534.91.camel@gandalf.stny.rr.com> <877h0jgx80.fsf@rustcorp.com.au> <1327545664.22710.78.camel@gandalf.stny.rr.com> <20120126102836.GD3853@elte.hu> <1327585945.22710.87.camel@gandalf.stny.rr.com> <20120126135504.GA13107@elte.hu> <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com> <20120126183946.GA14709@elte.hu>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 27 Jan 2012 13:32:17 +1030
Message-ID: <87ehuldf0m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 19:39:46 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> Ok, i like this one best. Rusty, does it look good to you too?

No, the if (module) test belongs in the inline wrapper (since gcc knows
that at compile time).

But the rest is good.

Thanks!
Rusty.

