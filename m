Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1KCUZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 16:25:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36456 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1KCUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 16:25:42 -0400
MIME-Version: 1.0
X-Originating-IP: [71.233.110.244]
In-Reply-To: <alpine.LFD.2.02.1111021901440.2829@ionos>
References: <1320175784-6745-1-git-send-email-edward.donovan@numble.net> <alpine.LFD.2.02.1111021901440.2829@ionos>
From: Edward Donovan <ed@numble.net>
Date: Thu, 3 Nov 2011 16:25:20 -0400
Message-ID: <CADdbW+FENazoLGPYTdrQ8qitk_Mc=2gckfxTb2cUH2jJ3qb1RA@mail.gmail.com>
Subject: Re: [PATCH] genirq: spurious.c: fix regression that broke irqfixup,irqpoll
To: Thomas Gleixner <tglx@linutronix.de>
Cc: maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 2, 2011 2:02 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>
> Good catch! I was staring at it with my conference and flu damaged
> brain ....
>

Thanks, Thomas.  It had me running around for quite a while before I
caught it. :)

I hoped this had nailed the failure of irqfixup/poll, since the .39
merge window.  But I have one machine where this fix doesn't help.
(With this patch, 2.6.39+ went from never handling that bad irq, to
handling it in a fraction of bootups.  I have to dig into that
more.)

On my Ubuntu bug report I have asked the other reporters for
testing, but haven't heard yet.

It may be back to the bisecting board for me, and I'll post again
if I learn anything.

 Ed
