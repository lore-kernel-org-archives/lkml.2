Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0JEHvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:51:03 -0400
Received: from www.tglx.de ([62.245.132.106]:44396 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab0JEHvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:51:01 -0400
Date: Tue, 5 Oct 2010 09:30:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
In-Reply-To: <201010051544.52269.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6> <201010051544.52269.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Rusty Russell wrote:

> On Tue, 5 Oct 2010 09:13:38 am Thomas Gleixner wrote:
> > The patch below cures it.
> 
> Using module_mutex here is just lazy...  Here's 5c, go buy your own lock :)

I'm lazy. :) My evil plan of sending a crap patch so it gets replaced
by a nice one worked well :)

Thanks,

	tglx
