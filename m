Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1LVJOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:14:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:58319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1LVJOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:14:18 -0500
Message-ID: <1324545242.24803.11.camel@twins>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Dec 2011 10:14:02 +0100
In-Reply-To: <20111222090352.GA11831@elte.hu>
References: <20111221105739.798864333@chello.nl>
	 <20111221111143.620776435@chello.nl>
	 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
	 <20111222070212.GA9593@elte.hu> <1324543413.24803.7.camel@twins>
	 <20111222090352.GA11831@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 10:03 +0100, Ingo Molnar wrote:

> Could be made part of the locking self-tests - that way it does 
> not add an extra config option! ;-)

Fair chance it will blow up and disable lockdep for pretty much every
console implementation out there, except 8250serial when used in
conjunction with all patches in this thread.

Maybe not the normal vga console, but I haven't tried on a machine that
has a monitor attached yet (they're usually not on remote power switches
and I'm too lazy to reach over and press reset).


