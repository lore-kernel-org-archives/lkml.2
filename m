Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab0KOOGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:06:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab0KOOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:06:40 -0500
Date: Mon, 15 Nov 2010 15:06:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
        andi@firstfloor.org, lwoodman@redhat.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
Message-ID: <20101115140632.GI7269@basil.fritz.box>
References: <20101110164413.GA5360@nowhere>
 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
 <20101115134325.GA5410@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115134325.GA5410@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually I don't see any reason right now to trace only kernel faults. Do you?
> If that's needed, one can still check on post-processing that the address
> was in the kernel.

I think the idea is to get more context on oopses. If the event only covers
that the overhead in the common case (minus *_user) is much less,
versus the more generalized points you use.

For tracing the whole page fault me think it's better to have 
a generalized exception tracer with a filter on page fault.

-Andi
