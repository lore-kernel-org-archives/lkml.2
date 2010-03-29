Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0C2S2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:28:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57076 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751045Ab0C2S2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:28:22 -0400
Date: Mon, 29 Mar 2010 20:27:36 +0200
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
Message-ID: <20100329182736.GA1373@ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz> <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com> <20100308072858.GA29939@atrey.karlin.mff.cuni.cz> <20100308082530.GA1982@atrey.karlin.mff.cuni.cz> <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz> <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz> <20100321204335.GM1933@elf.ucw.cz> <1269207753.13196.53.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269207753.13196.53.camel@utx.utx.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-21 22:42:33, Stanislav Brabec wrote:
> Pavel Machek píše v Ne 21. 03. 2010 v 21:43 +0100:
> > On Fri 2010-03-12 10:07:04, Stanislav Brabec wrote:
> 
> > > > > Good tip. It seems that nobody ported driver for the voltage control
> > > > > chip ISL6271 from 2.4 kernel, and bootloader probably does not set
> > > > > correct values.
> > 
> > Are we sure about this one? If we have wrong voltages on various
> > parts, that kind-off explains it.
> > 
> > Would it be possible to measure (Voltmeter) difference between 2.4
> > kernel and 2.6 kernel?
> 
> If you are ready to run Zaurus in dismantled state, then yes. Measure on
> the upper pin of the large coil in the center of the
> http://www.penguin.cz/~utx/zaurus/pcbt_uc.jpg image or on the testpoint
> nearby (probably to the right).

I'm not comfortable dismantling it :-(.

> Alternatively, it is possible to write a driver. It is just one byte
> write and one byte read via I2C.

Do you know what byte it is? That sounds easy enough...

But I have small problem now -- zaurus seems to work mostly fine
now. Does it depend on temperature, or what? Tried mtest,
nothing. Tried compiling kernel, ok... Will try few more times...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
