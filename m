Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0KPUr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:47:57 -0500
Received: from ist.d-labs.de ([213.239.218.44]:55113 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab0KPUr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:47:56 -0500
Date: Tue, 16 Nov 2010 21:47:26 +0100
From: Florian Mickler <florian@mickler.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Keith Packard <keithp@keithp.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101116214726.440e9846@schatten.dmk.lab>
In-Reply-To: <20101116121107.7728e971@jbarnes-desktop>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<20101011154826.440b4990@jbarnes-desktop>
	<20101011164014.5a11ee48@jbarnes-desktop>
	<201010122101.17812.rjw@sisk.pl>
	<20101012124938.47170457@jbarnes-desktop>
	<20101116204645.2c105e9b@schatten.dmk.lab>
	<20101116121107.7728e971@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 12:11:07 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 16 Nov 2010 20:46:45 +0100
> Florian Mickler <florian@mickler.org> wrote:
> 
> > On Tue, 12 Oct 2010 12:49:38 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > I don't think I buy that VGA is special anyway, at least not for KMS
> > > enabled kernels, where vgacon and the BIOS can't assume anything about
> > > graphics state anymore.  More generally, I don't think BIOSes have been
> > > able to assume anything about the current graphics state since Windows
> > > 3.1, when most platforms stopped using BIOS calls and/or VGA regs for
> > > mode setting.
> > > 
> > > Thoughts?
> > > 
> > 
> > does this need to go to 2.6.36.y? (is it already on it's way?)
> > 
> > commit 97c145f7c87453cec90e91238fba5fe2c1561b32
> > Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Date:   Fri Nov 5 15:16:36 2010 -0400
> > 
> >     PCI: read current power state at enable time
> 
> I hadn't planned on pushing this to stable, but if you have a need
> for it there, feel free to propose it.
> 
No, I don't need it. I was closing a regression tracker and thought I
should check. You can judge the impact better then me. 

Regards,
Flo
