Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0CUUns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 16:43:48 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753522Ab0CUUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 16:43:43 -0400
Date: Sun, 21 Mar 2010 21:43:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Andy Green <andy@warmcat.com>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       thommycheck@gmail.com, zaurus-devel@www.linuxtogo.org,
       omegamoon@gmail.com
Subject: Re: bit errors on spitz
Message-ID: <20100321204335.GM1933@elf.ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
 <4B98EF5D.5000609@warmcat.com>
 <1268322155.3990.114.camel@hammer.suse.cz>
 <4B995EE1.1050609@warmcat.com>
 <1268384824.4963.35.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268384824.4963.35.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-12 10:07:04, Stanislav Brabec wrote:
> Andy Green wrote: 
> > On 03/11/10 15:42, Somebody in the thread at some point said:
> > > Andy Green wrote:
> > >
> > >> I saw very similar failures for a long time on our iMX31 based device.
> > >> Eventually I found a Freescale errata where the RAM inside the USB2
> > >> macrocell started to make single bit errors below 1.38V Vcore; ours was
> > >> 1.4V at that time but dipped on CPU load.
> > >
> > > Good tip. It seems that nobody ported driver for the voltage control
> > > chip ISL6271 from 2.4 kernel, and bootloader probably does not set
> > > correct values.

Are we sure about this one? If we have wrong voltages on various
parts, that kind-off explains it.

Would it be possible to measure (Voltmeter) difference between 2.4
kernel and 2.6 kernel?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
