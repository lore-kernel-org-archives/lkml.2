Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab0KKIWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:22:38 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:42853 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0KKIWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:22:37 -0500
Subject: Re: PROBLEM: i915 modesetting - weird offset graphics
 (v2.6.37-rc1-27-gff8b16d)
From: Jon Masters <jonathan@jonmasters.org>
To: maciej.rutecki@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        chris@chris-wilson.co.uk, intel-gfx@lists.freedesktop.org
In-Reply-To: <201011110902.32267.maciej.rutecki@gmail.com>
References: <1288855558.3916.293.camel@constitution.bos.jonmasters.org>
	 <201011110902.32267.maciej.rutecki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 11 Nov 2010 03:22:34 -0500
Message-ID: <1289463754.3916.593.camel@constitution.bos.jonmasters.org>
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

On Thu, 2010-11-11 at 09:02 +0100, Maciej Rutecki wrote:
> On czwartek, 4 listopada 2010 o 08:25:58 Jon Masters wrote:
> > Folks,
> > 
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
> > 
> > Said system will likely be at plumbers in the am...
> > 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=22712
> for your bug report, please add your address to the CC list in there, thanks!

Thanks. I requested the k.o BZ to send me a new password over the
weekend, which was delayed by a few hours and then I didn't get around
to this. FWIW, the bug has a fix on the intel-gfx list.

Jon.


