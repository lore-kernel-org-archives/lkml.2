Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0EHSEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 14:04:05 -0400
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:54323 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0EHSED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 14:04:03 -0400
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
X-Spam-Spammy: 0.957-+--H*r:mail.ffwll.ch, 0.940-+--H*Ad:D*ffwll.ch,
	0.920-+--H*Ad:D*ch
Date: Sat, 8 May 2010 20:04:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Nils Radtke <lkml@Think-Future.de>
Cc: linux-kernel@vger.kernel.org,
       "Jan Evert van Grootheest (SDG)" <j.e.van.grootheest@caiway.nl>,
       dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference,
 i915_gem_object_move_to_active
Message-ID: <20100508180435.GB17682@viiv.ffwll.ch>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.de>,
	linux-kernel@vger.kernel.org,
	"Jan Evert van Grootheest (SDG)" <j.e.van.grootheest@caiway.nl>,
	dri-devel@lists.freedesktop.org
References: <20100508143213.GB30514@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100508143213.GB30514@localhost>
X-Operating-System: Linux viiv 2.6.34-rc5-00127-g3008a73 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 08, 2010 at 04:32:13PM +0200, Nils Radtke wrote:
> This report might actually be related (in fact, same notebook):
> 
>   http://permalink.gmane.org/gmane.linux.kernel/981318

May be or may not be related. Given that your problem (and the bz entry
I've linked to) are clear kernel bugs, hw (besides the fact that both are
using intel graphics) shouldn't really matter.

> Daniel, I'm not sure I got what you intended to tell me w/:
> > There's a test patch in that bz entry (the one that adds two BUG_ONs).
> > If you're hitting these, is rather likely that it's the same bug.
> bz entry?
> I can't tell whether it's this exact bug. And I'm unfortunately a bit limited
> in using the notebook to test and crash it, it's not mine and therefore not always 
> there to play with, if you intended me to apply some patch and test whether the 
> notebook will crash at the BUG_ON()s.

I've link the bz entry in my original reply. Anyway, here it is again:

https://bugzilla.kernel.org/show_bug.cgi?id=15664

There's a kernel patch there (the one adding two BUG_ONs, the others are
crap). I've you could apply this and test, that would be great - if you
hit one of these BUG_ONs you've got the same issue with very high
probability. If this is the case, please add yourself to the cc list of
this bug with a "me too" containing some details 'bout your hw + links to
all other preexisting bugs/discussion concerning your problem.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
