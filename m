Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1C2RsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:48:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1C2RsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:48:23 -0400
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1301405984.2250.402.camel@laptop>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
	 <20110328171217.GA8529@home.goodmis.org>
	 <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
	 <1301405984.2250.402.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 19:50:32 +0200
Message-ID: <1301421032.2250.432.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 15:39 +0200, Peter Zijlstra wrote:
> 
> That said, there are some out-standing issues with rw_locks and lockdep,
> Gautham and I worked on that for a while but we never persevered and
> finished it..
> 
>   http://lkml.org/lkml/2009/5/11/203 

I just did a quick rebase onto tip/master (compile tested only):

  http://programming.kicks-ass.net/sekrit/patches-lockdep.tar.bz2

That series needs testing and a few patches to extend the
lib/locking-selftest* bits to cover the new functionality.

