Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2EVFOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:14:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61322 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2EVFOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	<CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	<1337084609.27020.156.camel@laptop>
	<CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	<1337086834.27020.162.camel@laptop>
	<CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	<1337096141.27694.82.camel@twins>
	<1337193010.27694.146.camel@twins>
	<CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	<1337468148.573.139.camel@twins>
	<CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
Date: Tue, 22 May 2012 13:14:47 +0800
Message-ID: <CANQmPXjiqtDE_4ZmNrtrb9qjB=gyv=NiPr3pdaHFirSs0T3ptQ@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Chen <hi3766691@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mou Chen <hi3766691@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:38 AM, Chen <hi3766691@gmail.com> wrote:
> Still you are just trying to said that your code is not bloated?
> Up to over 500K for a cpu scheduler. Laughing

So please stop increasing the size of cpu scheduler's code. Users
can't benefit anything from that. Also the interactivity problem of
scheduler is still exist though it improves a lot already.

It is better to stop bloating. Isn't ?

Also I m quite agree with Linus. The model of the scheduler now is
complex and there are many *UNNECESSARY* code. I CAN'T REALLY BENEFIT
ANYTHING. I just make my kernel with -j2 and the music is already
sucking![Intel E7500, 2.9GHZ, two core]. It can show that how the
interactivity problem is serious with mainline cpu scheduler. I know
it is not all the fault of mainline cpu scheduler but it is still a
big interactivity problem with it. [me think that Peter is proud of
his insane-box-supporting stuff]
