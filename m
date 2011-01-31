Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1AaNak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:30:40 -0500
Received: from peer.zerties.org ([188.40.33.175]:56607 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1AaNaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:30:39 -0500
X-Greylist: delayed 1812 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Jan 2011 08:30:39 EST
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vamos@i4.informatik.uni-erlangen.de, Julia Lawall <julia@diku.dk>
Subject: Re: [ANNOUNCE] undertaker 1.0
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
References: <87y666tvag.fsf@faui44a.informatik.uni-erlangen.de>
	<alpine.LFD.2.00.1101282126210.31804@localhost6.localdomain6>
Date: Mon, 31 Jan 2011 14:00:24 +0100
In-Reply-To: <alpine.LFD.2.00.1101282126210.31804@localhost6.localdomain6>
	(Thomas Gleixner's message of "Fri, 28 Jan 2011 21:41:18 +0100 (CET)")
Message-ID: <86sjw9jkif.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> The one in manage.c is not:
>
>  921 #ifdef CONFIG_IRQ_RELEASE_METHOD
>
> CONFIG_IRQ_RELEASE_METHOD is set by arch/um. Ditto for include/linux/irq.h

This problem was the result of an implementation bug. We didn't create a
feature model for um. This is now fixed in our master branch and will be
in the next minor release.

> It'd be nice if the web interface would have a knob to jump to the
> next red section. Scrolling through is annoying.

I generated a new code browser for -rc2[1]. There you can press 'n' to jump
to the next defect. I've only tested the javascript code with chromium,
but it should work anywhere else too.

[1] http://www4.informatik.uni-erlangen.de/Research/VAMOS/linux-trees/v2.6.38-rc2/
-- 
(λ x . x x) (λ x . x x) -- See how beautiful the lambda is
No documentation is better than bad documentation

