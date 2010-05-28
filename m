Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0E1N3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:29:37 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752210Ab0E1N3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:29:36 -0400
Date: Fri, 28 May 2010 15:29:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       markgross@thegnar.org, Brian Swetland <swetland@google.com>,
       linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100528132925.GA2677@ucw.cz>
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <20100506134015.GA23426@srcf.ucam.org>
 <20100506170151.GA30928@atomide.com>
 <20100506170956.GA28104@srcf.ucam.org>
 <20100506171453.GC30928@atomide.com>
 <20100506172201.GA28578@srcf.ucam.org>
 <20100506173807.GD30928@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506173807.GD30928@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Why would you need to constantly try to suspend in that case?
> > 
> > Because otherwise you're awake for longer than you need to be.
> 
> If your system is idle and your hardware supports off-while-idle,
> then that really does not matter. There's not much of a difference
> in power savings, we're already talking over 10 days on batteries
> with just off-while-idle on omaps.

Makes me wish g1 was omap based... it looks like you have superior hw.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
