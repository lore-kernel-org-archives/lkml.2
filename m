Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2AJJYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:24:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2AJJYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:24:07 -0500
Message-ID: <1326187433.2442.101.camel@twins>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated
 during context switching
From: Peter Zijlstra <peterz@infradead.org>
To: Chanho Min <chanho0207@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, chanho.min@lge.com
Date: Tue, 10 Jan 2012 10:23:53 +0100
In-Reply-To: <CAOAMb1A3DNU87oFRHPJZc5OARtsN4wjarmr+Ffu9oB_b0HOioA@mail.gmail.com>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
	 <1325786132.3508.1.camel@twins>
	 <1325787342.12696.59.camel@gandalf.stny.rr.com>
	 <1325799904.3508.12.camel@twins>
	 <CAOAMb1A3DNU87oFRHPJZc5OARtsN4wjarmr+Ffu9oB_b0HOioA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 17:13 +0900, Chanho Min wrote:
> So Will this be applied?  It will be critical and very hard to debug.
> ( pretty rare, sometimes system hang without any message )
> It has been well tested on our ARM platform.
> 
> 
Yeah, thanks. I've queued it, should show up in -tip soonish.
