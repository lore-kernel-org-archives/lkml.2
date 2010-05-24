Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0EYHwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:52:34 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754307Ab0EYHwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:52:32 -0400
Date: Mon, 24 May 2010 23:25:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>, Alan Stern <stern@rowland.harvard.edu>,
       Paul Walmsley <paul@pwsan.com>, Arve Hj?nnev?g <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Beno?t Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
       Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100524212511.GC1286@ucw.cz>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
 <Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
 <20100513191717.GA3428@atomide.com>
 <20100513192522.GA19256@srcf.ucam.org>
 <20100513194205.GC3428@atomide.com>
 <20100513195349.GB19722@srcf.ucam.org>
 <20100513200003.GE3428@atomide.com>
 <20100513200814.GA20254@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513200814.GA20254@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-05-13 21:08:14, Matthew Garrett wrote:
> On Thu, May 13, 2010 at 01:00:04PM -0700, Tony Lindgren wrote:
> 
> > The system stays running because there's something to do. The system
> > won't suspend until all the processors hit the kernel idle loop and
> > the next_timer_interrupt_critical() returns nothing.
> 
> At which point an application in a busy loop cripples you. I think we 

Application running busy loop already cripples you, with power going
from 15W to 50W in thinkpad case. Just avoid badly written apps.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
