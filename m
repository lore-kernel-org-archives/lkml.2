Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0LQVCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:02:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43574 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab0LQVCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:02:14 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101217192814.GA16133@redhat.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <20101217165414.GA8997@redhat.com> <1292607781.2266.295.camel@twins>
	 <1292609740.2266.323.camel@twins>  <20101217192814.GA16133@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 22:02:05 +0100
Message-ID: <1292619725.2708.112.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 20:28 +0100, Oleg Nesterov wrote:
> Well. All I can say, I'll try to re-read this code with the fresh head ;)

Right, good plan ;-)

I'll try and clean up my current mess and try to post a new series this
weekend (although it looks to be a busy weekend, with the holidays
coming up and all).

