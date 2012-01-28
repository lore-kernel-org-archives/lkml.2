Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2A1EFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 23:05:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55262 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2A1EFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 23:05:33 -0500
MIME-Version: 1.0
In-Reply-To: <1326187433.2442.101.camel@twins>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
	<1325786132.3508.1.camel@twins>
	<1325787342.12696.59.camel@gandalf.stny.rr.com>
	<1325799904.3508.12.camel@twins>
	<CAOAMb1A3DNU87oFRHPJZc5OARtsN4wjarmr+Ffu9oB_b0HOioA@mail.gmail.com>
	<1326187433.2442.101.camel@twins>
Date: Sat, 28 Jan 2012 13:05:31 +0900
Message-ID: <CAOAMb1AThA3qowiGKBP--YeWP09fvpP95XNREez-tDxBmfLhMA@mail.gmail.com>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated during
 context switching
From: Chanho Min <chanho0207@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, chanho.min@lge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 6:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Yeah, thanks. I've queued it, should show up in -tip soonish.
Hi,
I haven't seen it yet in tip tree. Is there any other issue?

Thanks,
