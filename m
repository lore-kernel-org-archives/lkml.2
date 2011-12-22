Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1LVKUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:20:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51471 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1LVKUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:20:14 -0500
Message-ID: <1324549195.24803.13.camel@twins>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Dec 2011 11:19:55 +0100
In-Reply-To: <20111222101556.GA12976@elte.hu>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.620776435@chello.nl>
	 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
	 <20111222070212.GA9593@elte.hu> <1324543413.24803.7.camel@twins>
	 <20111222090352.GA11831@elte.hu> <1324545242.24803.11.camel@twins>
	 <20111222101556.GA12976@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 11:15 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2011-12-22 at 10:03 +0100, Ingo Molnar wrote:
> > 
> > > Could be made part of the locking self-tests - that way it 
> > > does not add an extra config option! ;-)
> > 
> > Fair chance it will blow up and disable lockdep for pretty 
> > much every console implementation out there, except 8250serial 
> > when used in conjunction with all patches in this thread.
> 
> If it blows up without being fixed then it's not a good idea.

Right, and we can't fix them, its 'allowed'. I just wanted to make sure
I had the debug option so that I can debug my own serial consoles to
make sure they do behave nicely.

> > Maybe not the normal vga console, but I haven't tried on a 
> > machine that has a monitor attached yet (they're usually not 
> > on remote power switches and I'm too lazy to reach over and 
> > press reset).
> 
> The VGA console does not require a monitor attached.

Ah, right, I could just add it to the console list together with the
serial thing.
