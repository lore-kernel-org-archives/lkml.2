Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2FLNPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:15:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53067 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab2FLNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <1338813658.28282.43.camel@twins>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
	<1338813658.28282.43.camel@twins>
Date: Tue, 12 Jun 2012 17:15:32 +0400
Message-ID: <CANaxB-xZ+KDZGMb8G1s5q+R_jzdWbP_FFxiGR=s4L90_tUqNjQ@mail.gmail.com>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Andrew Wagin <avagin@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> So I really don't like this stuff either.. :-)
>
> Mostly because it adds very similar stuff to what's already there and
> then doesn't try and consolidate things.
>
> And partly because you're measuring the 'wrong' thing, the delay between
> sched-out and sched-in includes a number of things, only one part of
> that is the delay due to blocking.
>
> And as a result you need that hideous prev_state crap.
>

Yes, you are right.

>
>
> Would something like the below work?

Yes, I like it. Are you going to commit this? Thank for this work.
