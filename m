Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1CHIfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:35:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44269 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756368Ab1CHIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:35:06 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/HaxsE8knHG6FkznHnOBgRLN99OngaQIOBem35UK
	3OOwUMv77W4Rfs
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTinPuCg-fGBtOgYSwVf1_67dr9uzw7a-8TfxLUuW@mail.gmail.com>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <AANLkTinPuCg-fGBtOgYSwVf1_67dr9uzw7a-8TfxLUuW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 09:28:12 +0100
Message-ID: <1299572892.7949.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 16:19 +0800, Yong Zhang wrote:
> On Mon, Mar 7, 2011 at 5:33 PM, Mike Galbraith <efault@gmx.de> wrote:
> > Well, it does prevent complete death, but you have to be pretty darn
> > attentive to notice that the patient is still technically alive ;-)
> >
> > As such, turning borrowing off by default, and making borrowing up to
> > within a micron of 100% CPU an opt-in feature likely makes more sense.
> 
> Another idea comes into my head is: disable runtime borrowing for
> root_task_group forever by default, but keep current behavior
> for the sub-groups :)

Yeah, that's one of the things I was pondering.  No parent, no
borrowing.

	-Mike

