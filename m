Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0HBFeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 01:34:18 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35624 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0HBFeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 01:34:17 -0400
Date: Mon, 2 Aug 2010 07:34:00 +0200
From: Florian Mickler <florian@mickler.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802073400.68a6edd7@schatten.dmk.lab>
In-Reply-To: <20100801210548.23f77ff6@infradead.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<20100802030304.GU2470@linux.vnet.ibm.com>
	<20100801210548.23f77ff6@infradead.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 1 Aug 2010 21:05:48 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> I'm a little worried that this whole "I need to block suspend" is
> temporary. Yes today there is silicon from ARM and Intel where suspend
> is a heavy operation, yet at the same time it's not all THAT heavy
> anymore.... at least on the Intel side it's good enough to use pretty
> much all the time (when the screen is off for now, but that's a memory
> controller issue more than anything else). I'm pretty sure the ARM guys
> will not be far behind.

I think that the only thing that really matters (longterm) with suspend
is that processes don't get scheduled anymore when the system is
suspended.

Cheers,
Flo


