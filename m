Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1HML7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 07:59:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1HML7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 07:59:03 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt11
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 13 Aug 2011 13:58:33 +0200
In-Reply-To: <1313236135.4486.10.camel@marge.simson.net>
References: <1313232790.25267.7.camel@twins>
	 <1313236135.4486.10.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313236713.25267.10.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 13:48 +0200, Mike Galbraith wrote:
> On Sat, 2011-08-13 at 12:53 +0200, Peter Zijlstra wrote:
> > Whee, I can skip release announcements too!
> > 
> > So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> > grabs.
> > 
> > Changes include (including the missing -rt10):
> > 
> >   - hrtimer fix that should make RT_GROUP work again
> >   - RCU fixes that should make the RCU stalls go away
> 
> Oh goodie, I was just looking at some of those.
> 
> coverdale:/abuild/mike/linux-3.0-rt/:[1]# wget http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> --2011-08-13 13:38:13--  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> Resolving www.kernel.org... 130.239.17.5, 199.6.1.165, 2001:6b0:e:4017:1994:313:1:0, ...
> Connecting to www.kernel.org|130.239.17.5|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 2011-08-13 13:38:13 ERROR 404: Not Found.
> 
> Aw poo.  Darn mirrors. 

Try -rt10, except for an SMP=n build fix its identical.. kernel.org
seems to experience some trouble atm..
