Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0LEFMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 00:12:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0LEFME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 00:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KKl/HRxLXCh7H0K0rMiKBqeiiJno44qaYSdT3og9ITgoQPbhN/6CIna1T9ZW0BYiTv
         21+u1MSzladLReS085AA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimmZE0QROje3vLKJOa+uVFfNqiGNF_MJ9vt9xHW@mail.gmail.com>
References: <20101121133744.GA10765@elte.hu> <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net> <4CF5C379.8030204@google.com>
 <1291184173.7466.147.camel@marge.simson.net> <4CF87C14.8000708@google.com> <AANLkTimmZE0QROje3vLKJOa+uVFfNqiGNF_MJ9vt9xHW@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Sat, 4 Dec 2010 21:11:29 -0800
Message-ID: <AANLkTikPwXjNixYg+Wc=hrfPzpy7uygQ+zmYUKYAcrkd@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 3:55 PM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> On 3 December 2010 05:11, Paul Turner <pjt@google.com> wrote:
>>
>> I actually don't have a desktop setup handy to test "interactivity" (sad but
>> true -- working on grabbing one).  But it looks better on under synthetic
>> load.
>>
>
> What tools are actually used to test "interactivity" ?
> I posted a tool to the list some time ago, but I don't think anyone noticed.
> My tool is very simple.
> When you hold a key down, it should repeat. It should repeat at a
> constant predictable interval.
> So, my tool just waits for key presses and times when each one occurred.
> The tester simply presses a key and holds it down.
> If the time between each key press is constant, it indicates good
> "interactivity". If the time between each key press varies a lot, it
> indicates bad "interactivity".
> You can reliably test if one kernel is better than the next using
> actual measurable figures.
>
> Kind Regards
>
> James
>

Could you drop me a pointer?  I can certainly give it a try.  It would
be extra useful if it included any histogram functionality.

I've been using a combination of various synthetic wakeup and load
scripts and measuring the received bandwidth / wakeup latency.

They have not succeeded in reproducing the starvation or poor latency
observed by Mike above however.  (Although I've pulled a box to try
reproducing his exact conditions [ e.g. user environment ] on Monday).
