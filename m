Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0LDXz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 18:55:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55966 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0LDXz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 18:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wla8bkHn+8wDv8kPGKX0HUt0MU/FGLL3/W1Z10zi8LRWof+z2UTCmJBjK7DFDHhGen
         pRwfj+L27F52KuFdjPLu4dLBqBT1ZQCSPhbAMP7nfWblNYRGUBx/X/CMp3mKi4H2XRKk
         f6KHFq0SRmn5xB0D87Ydvly+szbp/BGe/zp0E=
MIME-Version: 1.0
In-Reply-To: <4CF87C14.8000708@google.com>
References: <20101121133744.GA10765@elte.hu>
	<1290700829.4759.16.camel@maggy.simson.net>
	<1290954299.30515.15.camel@marge.simson.net>
	<4CF5C379.8030204@google.com>
	<1291184173.7466.147.camel@marge.simson.net>
	<4CF87C14.8000708@google.com>
Date: Sat, 4 Dec 2010 23:55:57 +0000
Message-ID: <AANLkTimmZE0QROje3vLKJOa+uVFfNqiGNF_MJ9vt9xHW@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2010 05:11, Paul Turner <pjt@google.com> wrote:
>
> I actually don't have a desktop setup handy to test "interactivity" (sad but
> true -- working on grabbing one).  But it looks better on under synthetic
> load.
>

What tools are actually used to test "interactivity" ?
I posted a tool to the list some time ago, but I don't think anyone noticed.
My tool is very simple.
When you hold a key down, it should repeat. It should repeat at a
constant predictable interval.
So, my tool just waits for key presses and times when each one occurred.
The tester simply presses a key and holds it down.
If the time between each key press is constant, it indicates good
"interactivity". If the time between each key press varies a lot, it
indicates bad "interactivity".
You can reliably test if one kernel is better than the next using
actual measurable figures.

Kind Regards

James
