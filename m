Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab2IFSf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:35:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFSfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:35:25 -0400
Message-ID: <1346956518.18408.64.camel@twins>
Subject: Re: [PATCH 0/4] (Was: lockdep trace from posix timers)
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 06 Sep 2012 20:35:18 +0200
In-Reply-To: <20120906180100.GA9479@redhat.com>
References: <1345475530.23018.50.camel@twins>
	 <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins>
	 <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins>
	 <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com>
	 <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com>
	 <20120826191132.GA3743@redhat.com> <20120906180100.GA9479@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 20:01 +0200, Oleg Nesterov wrote:
> Ping...

Right, email backlog :-)

> Peter, do you think you can do your make-it-lockless patch (hehe, I
> think this is not possible ;) on top?

Sure, I was trying to see if I could play games with the _cancel
semantics that would satisfy the two callsites and be possible. No joy
yet though.

Anyway, do you want me to take these patches through -tip?

