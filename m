Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1BTNVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:21:38 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:47680 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1BTNVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:21:37 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.941-+--H*Ad:D*ffwll.ch,
	0.930-+--H*Ad:D*ch
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Sun, 20 Feb 2011 14:21:16 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Indan Zupancic <indan@nul.nu>
Cc: Daniel Vetter <daniel@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
 a00b10c360b35d6431a94cb
Message-ID: <20110220132115.GC3514@viiv.ffwll.ch>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
 <20110219182511.GA3977@viiv.ffwll.ch>
 <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
 <20110220105514.GB3514@viiv.ffwll.ch>
 <b51c68e52b0495f1c354f200bc50c7ec.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b51c68e52b0495f1c354f200bc50c7ec.squirrel@webmail.greenhost.nl>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 12:19:14PM +0100, Indan Zupancic wrote:
> Hi,
> 
> Good news:
> 
> On Sun, February 20, 2011 11:55, Daniel Vetter wrote:
> >> > I've created two quick patches to check a few theories, please test them
> >> > (both patches independently and both together). Patches attached.
> >>
> >> Tried with both applied, doesn't change anything.
> >
> > I've just noticed that one of the patches (the 2nd one) doesn't work as
> > advertised. Please retest with the attached one.
> 
> This one fixes it!

Well, don't start jumping around, yet. These patches are just to rule out
some theories. Now: Is it fixed with just the 2nd patch alone or do you
need both patches? This is very important, so please test extensively
whether there are really no corruptions with just the 2nd patch.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
