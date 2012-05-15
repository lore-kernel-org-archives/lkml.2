Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2EOJHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:07:11 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64628 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab2EOJHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	<CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	<CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
Date: Tue, 15 May 2012 11:07:07 +0200
Message-ID: <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Vincent Guittot <vincent.guittot@linaro.org>
To: mou Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2012 10:34, mou Chen <hi3766691@gmail.com> wrote:
> Hi Vincent
>
> There is no necessary to change the scheduling policy for for a
> SPECIFIC work. In case changing the scheduling policy just for this
> reason will drop the total performance at all. People know that
> desktop scheduler is for interactivity and server scheduler is for
> throughput and we are just designing a scheduler for these 2 groups of
> task.

Hi Chen,

First of all, I'm not sure that limiting the scheduling policy to
server and desktop mode is the right solution because Linux is used in
much more system like the embedded one.

Then, some weaknesses have been point out around the sched_mc and its
power saving policy and IIRC Peter was close to remove the sched_mc
stuff: http://thread.gmane.org/gmane.linux.kernel/1236846. It sounds
like the sched_mc should be removed, replace or at least rework to
have something smarter which takes into account more inputs than just
cluster or hyper threading links between cores which seems to be no
more sufficient.

So LPC would be a good place to discuss this point

Regards,
Vincent

>
> All right you may not agree with me at all. However, changing the
> policy for a SPECIFIC work is unnecessary. Or it is more better to
> share about "how to make a scheduler for yourselves" with people who
> don't know how to write a scheduler. :-)
>
>                                                      Chen
