Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0CUVlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:41:22 -0400
Received: from ns.penguin.cz ([84.21.108.25]:48896 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0CUVlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:41:20 -0400
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andy Green <andy@warmcat.com>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       thommycheck@gmail.com, zaurus-devel@www.linuxtogo.org,
       omegamoon@gmail.com
In-Reply-To: <20100321204335.GM1933@elf.ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>
	 <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz>
	 <20100321204335.GM1933@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Sun, 21 Mar 2010 22:42:33 +0100
Message-ID: <1269207753.13196.53.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek pí¹e v Ne 21. 03. 2010 v 21:43 +0100:
> On Fri 2010-03-12 10:07:04, Stanislav Brabec wrote:

> > > > Good tip. It seems that nobody ported driver for the voltage control
> > > > chip ISL6271 from 2.4 kernel, and bootloader probably does not set
> > > > correct values.
> 
> Are we sure about this one? If we have wrong voltages on various
> parts, that kind-off explains it.
> 
> Would it be possible to measure (Voltmeter) difference between 2.4
> kernel and 2.6 kernel?

If you are ready to run Zaurus in dismantled state, then yes. Measure on
the upper pin of the large coil in the center of the
http://www.penguin.cz/~utx/zaurus/pcbt_uc.jpg image or on the testpoint
nearby (probably to the right).

Alternatively, it is possible to write a driver. It is just one byte
write and one byte read via I2C.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

