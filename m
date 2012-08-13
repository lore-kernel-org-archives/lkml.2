Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2HMN7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:59:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:40123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2HMN7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:59:46 -0400
Message-ID: <1344866374.31459.30.camel@twins>
Subject: Re: [PATCH] sched: fix divide by zero at {thread_group,task}_times
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Mon, 13 Aug 2012 15:59:34 +0200
In-Reply-To: <20120813114820.GA2834@redhat.com>
References: <20120808092714.GA3580@redhat.com>
	 <1344455404.2440.35.camel@marge.simpson.net>
	 <1344456500.16728.15.camel@laptop> <20120813114820.GA2834@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 13:48 +0200, Stanislaw Gruszka wrote:
> 
> Is this or will be queued (I do not see it queued anywhere)? Or should
> I repost with above change? 

I've got it.. my queue lives at:

 http://programming.kicks-ass.net/sekrit/patches.tar.bz2

until Ingo gets around to stuffing them into -tip. That's usually only a
few days, but he's currently traveling so latency is somewhat increased.


