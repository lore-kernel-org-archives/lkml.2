Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2KCSII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 14:08:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59135 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2KCSIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 14:08:06 -0400
Date: Sat, 3 Nov 2012 14:07:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jani Nikula <jani.nikula@intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915: failure to interoperate with HP ZR30w using
 an X230
Message-ID: <20121103180759.GA5486@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <nsxa9v4ssgz.fsf@closure.thunk.org>
 <87hapcqu97.fsf@intel.com>
 <87zk34gok8.fsf@intel.com>
 <20121030203221.GA4537@thunk.org>
 <20121103005831.GA3978@thunk.org>
 <20121103102158.GP5755@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103102158.GP5755@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 11:21:58AM +0100, Daniel Vetter wrote:
> 
> Well, we know for sure that fdi link training is broken - it doesn't match
> at all what the spec says we should do. I've been working on this lately,
> since in quite a few circumstances the link train fails without the
> relevent bits indicating so. While testing I've also noticed that this
> entire thing is highly timing dependent, e.g. denpending upon which
> desktop is running and which tool I use to change the configuration it
> fails or succeeds.

So it is still (somewhat) broken in 3.7-rcX?  Certainly it seems to be
better (at least for me) than what was in 3.6.3.  Or are you saying I
may have just gotten lucky?  :-)

> So I have no suggestions for what could help your system and what should
> get backported, since the current code is still broken.

Thanks for your response and for your work in making the i915 driver
better.  I really appreciate your efforts.

Cheers,

						- Ted
