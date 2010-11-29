Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0K2RiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:38:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38110 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0K2RiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:38:04 -0500
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 18:37:48 +0100
Message-ID: <1291052268.32004.171.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 08:27 -0800, Linus Torvalds wrote:
> On Mon, Nov 29, 2010 at 3:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Well we totally re-wrote the cgroup load-balancer in -tip. The thing
> > currently in -linus is a utter crap because its very strongly serialized
> > across all cores (some people spend like 25% of their time in there).
> 
> Well, it seems that the rewrite is more crap than the "utter crap" in
> current -git. What does that make -tip? Super-utter-crap?
> 
> Peter - getting the wrong answer quickly is not any better than strong
> serialization.

I know, from the testing so far we _thought_ it was fairly sane.
Apparently there's still some work to do.


