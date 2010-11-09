Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0KITC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:02:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42781 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0KITC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:02:27 -0500
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Peter Zijlstra <peterz@infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20101109185516.GQ8332@bombadil.infradead.org>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	 <1287788622-25860-1-git-send-email-venki@google.com>
	 <1288001573.15336.52.camel@twins> <1288097074.15336.211.camel@twins>
	 <1288101958.15336.284.camel@twins> <1288381343.1988.12.camel@laptop>
	 <20101109185516.GQ8332@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 20:02:28 +0100
Message-ID: <1289329348.2191.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:55 -0500, Kyle McMartin wrote:
> On Fri, Oct 29, 2010 at 09:42:23PM +0200, Peter Zijlstra wrote:
> > 
> > not tested other than compile, but how does that look...?
> > 
> 
> Hi Peter,
> 
> I finally got around to building a test kernel for a user who had been
> reporting this against F-14 (2.6.35) but they report there's not much
> improvement.
> 
> Sorry. :/

Right, I tested it myself yesterday and got similar results. Does the
'simple' patch from a few posts back work for people?

 http://lkml.org/lkml/2010/10/26/150

If that does work I fudged the fancy math, if that doesn't work either
we're back to square zero.
