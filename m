Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722Ab2COOE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:04:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:40392 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab2COOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:04:55 -0400
Date: Thu, 15 Mar 2012 15:04:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <levinsasha928@gmail.com>
cc: John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: ntp: BUG: spinlock lockup on CPU#1
In-Reply-To: <CA+1xoqdeuorMi+=EZLpyrBN9L+J2o4SF-8meY=5Qypze9XrpiQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203151503530.2466@ionos>
References: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com> <CA+1xoqdeuorMi+=EZLpyrBN9L+J2o4SF-8meY=5Qypze9XrpiQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Sasha Levin wrote:

> On Thu, Mar 15, 2012 at 3:23 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > Hi all,
> >
> > I was doing some more fuzzing with trinity in a KVM tools guest, using
> > today's linux-next, when I've experienced a complete system lockup
> > (just in the guest ofcourse). After a bit I got the spew at the bottom
> > of this mail.
> >
> > From what I can tell from the logs, there were several threads waiting
> > on syscall results, and I suspect that the adjtimex() call on CPU3 is
> > somehow responsible for this lockup.
> 
> Oh, and I'm not sure if it's related or not, but I've started seeing
> the following spew every time I start fuzzing:
> 
> [   47.105987] ------------[ cut here ]------------
> [   47.106021] WARNING: at kernel/time/clockevents.c:209

It's unrelated, but I'm mighty curious how you manage that.

Thanks,

	tglx


