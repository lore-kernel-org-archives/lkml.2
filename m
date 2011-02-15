Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1BOMD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:03:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:56989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1BOMD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:03:26 -0500
Subject: Re: Kernel debugging method
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Amirali Shambayati <amirali.shambayati@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1297664070.7999.65.camel@marge.simson.net>
References: <AANLkTik1jWPn2QRCWz4r43WzD7rgH7Gn=HMOKdatNj=p@mail.gmail.com>
	 <1297664070.7999.65.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 13:03:02 +0100
Message-ID: <1297771382.2413.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 07:14 +0100, Mike Galbraith wrote:
> On Sun, 2011-02-13 at 13:56 +0330, Amirali Shambayati wrote:
> > Hello all,
> > 
> > Can anybody show me a method for kernel debugging? I just want to
> > modify one file(Noop IO scheduler).
> 
> I recommend the most powerful, and easiest to use, kernel debugger known
> to man: printk :)

You've forgotten the most fundamental one, your brain! Use it, it might
surprise you ;-)
