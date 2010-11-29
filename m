Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0K2Q2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:28:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602Ab0K2Q2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:28:03 -0500
MIME-Version: 1.0
In-Reply-To: <1291031593.32004.19.camel@laptop>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Nov 2010 08:27:40 -0800
Message-ID: <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 3:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Well we totally re-wrote the cgroup load-balancer in -tip. The thing
> currently in -linus is a utter crap because its very strongly serialized
> across all cores (some people spend like 25% of their time in there).

Well, it seems that the rewrite is more crap than the "utter crap" in
current -git. What does that make -tip? Super-utter-crap?

Peter - getting the wrong answer quickly is not any better than strong
serialization.

Anyway, I'm happy to hear that the problem hasn't reached mainline yet.

                    Linus
