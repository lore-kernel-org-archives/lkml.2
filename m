Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0KEVDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:03:25 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:44857 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0KEVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:03:24 -0400
Subject: Re: PROBLEM: i915 modesetting - weird offset graphics
 (v2.6.37-rc1-27-gff8b16d)
From: Jon Masters <jonathan@jonmasters.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: chris@chris-wilson.co.uk, intel-gfx@lists.freedesktop.org
In-Reply-To: <1288855779.3916.294.camel@constitution.bos.jonmasters.org>
References: <1288855558.3916.293.camel@constitution.bos.jonmasters.org>
	 <1288855779.3916.294.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 05 Nov 2010 17:03:50 -0400
Message-ID: <1288991030.3916.334.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 03:29 -0400, Jon Masters wrote:
> On Thu, 2010-11-04 at 03:25 -0400, Jon Masters wrote:
> 
> > I upgraded the userspace on my EeePC 1015PEM netbook to the latest
> > Fedora (F15) rawhide and booted a custom kernel in order to test both
> > the RC1 and also see if the now in-staging brcm80211 behaves better (it
> > doesn't, it still can't survive suspend at all, separate issue though).
> > 
> > The xrandr output is identical in both case, showing a mode of 1024x600
> > being the one that X is currently using. Booting with i915 modesetting
> > disabled does avoid the weird offset but of course X doesn't start. I
> > can bisect this if there isn't already some suggestions from the
> > audience, in particular is to what debug information you need.
> > 
> > Kernel: v2.6.37-rc1-27-gff8b16d
> > 
> > Photos:
> > 	http://www.flickr.com/photos/jonmasters/5145351220/
> > 	http://www.flickr.com/photos/jonmasters/5144748543/
> 
> Video:
> 	http://www.youtube.com/watch?v=43jc9_7n3kU
> 
> I'll bring it in to Plumbers in a few hours.

I took it to Plumbers and pinged a few people in person, but nobody was
all that interested. I am bisecting this at the moment, a few builds in.

Jon.


