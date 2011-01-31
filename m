Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1AaNYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:24:05 -0500
Received: from www.tglx.de ([62.245.132.106]:52049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1AaNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:24:03 -0500
Date: Mon, 31 Jan 2011 14:23:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
cc: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vamos@i4.informatik.uni-erlangen.de, Julia Lawall <julia@diku.dk>
Subject: Re: [ANNOUNCE] undertaker 1.0
In-Reply-To: <86sjw9jkif.fsf@peer.zerties.org>
Message-ID: <alpine.LFD.2.00.1101311422520.31804@localhost6.localdomain6>
References: <87y666tvag.fsf@faui44a.informatik.uni-erlangen.de> <alpine.LFD.2.00.1101282126210.31804@localhost6.localdomain6> <86sjw9jkif.fsf@peer.zerties.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Christian Dietrich wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > The one in manage.c is not:
> >
> >  921 #ifdef CONFIG_IRQ_RELEASE_METHOD
> >
> > CONFIG_IRQ_RELEASE_METHOD is set by arch/um. Ditto for include/linux/irq.h
> 
> This problem was the result of an implementation bug. We didn't create a
> feature model for um. This is now fixed in our master branch and will be
> in the next minor release.
> 
> > It'd be nice if the web interface would have a knob to jump to the
> > next red section. Scrolling through is annoying.
> 
> I generated a new code browser for -rc2[1]. There you can press 'n' to jump
> to the next defect. I've only tested the javascript code with chromium,
> but it should work anywhere else too.

Works nicely in firefox. Thanks a lot !

      tglx
