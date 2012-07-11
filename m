Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2GKAL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab2GKAL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:11:56 -0400
Date: Tue, 10 Jul 2012 20:11:45 -0400
From: Dave Jones <davej@redhat.com>
To: Greg Kroah-Hartmann <greg@kroah.com>
Cc: Joe Perches <joe@perches.com>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120711001145.GB10518@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg Kroah-Hartmann <greg@kroah.com>, Joe Perches <joe@perches.com>,
	Kay Sievers <kay@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20120709180328.GA4105@redhat.com>
 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop>
 <1341865916.6118.25.camel@joe2Laptop>
 <20120709204019.GA10111@kroah.com>
 <1341866664.6118.30.camel@joe2Laptop>
 <20120709205631.GA22980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709205631.GA22980@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 01:56:31PM -0700, Greg Kroah-Hartman wrote:
 > > > > That single patch doesn't apply cleanly to Linus'
 > > > > 8c84bf4166a4698296342841a549bbee03860ac0
 > > > > 
 > > > > What else is necessary?
 > > > > 
 > > > > Your tree seems to have a collection of random patches.
 > > > > 
 > > > > It might be useful to clone Linus' tree and produce a
 > > > > branch with all the necessary printk patches in it so
 > > > > someone else could pull it.
 > > > 
 > > > They should all now be in my driver-core-next branch that will show up
 > > > in the next linux-next release, so having a separate tree isn't
 > > > necessary.
 > > 
 > > I don't think so.
 > > 
 > > There are real defects in the existing code.
 > > 
 > > These are patches that are necessary _now_.
 > > not for a -next 3.6 future.
 > 
 > Oops, sorry, I ment to type, "driver-core-linus" above.

Can you get this to Linus asap please ? I just had an oops that scrolled
off the screen because the Code: line suffers the same problem.
Thankfully serial console caught most of it, but I had to hand-edit
a lot of crap just to make it readable again.

	Dave

