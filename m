Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0LHLMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:12:23 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49295 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab0LHLMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:12:20 -0500
Subject: Re: [patchlet] Re: Scheduler bug related to rq->skip_clock_update?
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        "Bjoern B. Brandenburg" <bbb.lst@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291802742.1417.9.camel@marge.simson.net>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
	 <1290359641.4816.69.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
	 <1290442781.16393.22.camel@maggy.simson.net>
	 <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
	 <20101205052819.GA2878@zhy> <1291613607.9457.5.camel@marge.simson.net>
	 <AANLkTimH0YN0fd4zOk3A=_Q7waqM=6V4pw4N+0g0-k=7@mail.gmail.com>
	 <1291624329.9457.38.camel@marge.simson.net>
	 <1291740081.2032.751.camel@laptop>
	 <1291748109.7475.20.camel@marge.simson.net>
	 <1291802742.1417.9.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 12:12:03 +0100
Message-ID: <1291806723.28378.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 11:05 +0100, Mike Galbraith wrote:
> 
> Crawling over flags had to be left for another day.
> 
Sure, just something we need to keep on the todo list (as if that thing
isn't bottomless ;-)

Anyway, Thanks I've queued it up (added stable@kernel.org as well) and
will hopefully still get it in .37.
