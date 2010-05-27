Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471Ab0E0SCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:02:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383Ab0E0SCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:02:49 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527175426.GC3543@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	 <20100527155201.GA31937@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	 <20100527192135.6c6543b3@schatten.dmk.lab>
	 <1274981127.27810.5597.camel@twins>
	 <20100527194241.52caaf37@schatten.dmk.lab>
	 <1274982729.27810.5703.camel@twins>  <20100527175426.GC3543@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 20:02:43 +0200
Message-ID: <1274983363.27810.5749.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:54 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:52:09PM +0200, Peter Zijlstra wrote:
> 
> > How so, event happens on hardware level, IRQ gets raised, CPU wakes up,
> > handler gets run, handler generates a task wakeup, runqueue isn't empty,
> > we run stuff.
> 
> If you're using idle-based suspend without any forced idling or blocking 
> of applications then you don't lose wakeups. People keep conflating 
> separate issues.

I still don't see how blocking applications will cause missed wakeups in
anything but a buggy application at worst, and even those will
eventually get the event when they unblock.

What seems to be the confusion?
