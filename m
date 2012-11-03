Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2KCKUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:20:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58937 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2KCKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:20:53 -0400
Date: Sat, 3 Nov 2012 11:21:58 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "Theodore Ts'o" <tytso@mit.edu>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915: failure to interoperate with HP ZR30w using
 an X230
Message-ID: <20121103102158.GP5755@phenom.ffwll.local>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jani Nikula <jani.nikula@intel.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <nsxa9v4ssgz.fsf@closure.thunk.org>
 <87hapcqu97.fsf@intel.com>
 <87zk34gok8.fsf@intel.com>
 <20121030203221.GA4537@thunk.org>
 <20121103005831.GA3978@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103005831.GA3978@thunk.org>
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 08:58:31PM -0400, Theodore Ts'o wrote:
> Ping?
> 
> On Tue, Oct 30, 2012 at 04:32:21PM -0400, Theodore Ts'o wrote:
> > On Tue, Oct 30, 2012 at 01:57:27PM +0200, Jani Nikula wrote:
> > > > [1] drm-intel-next-queued branch at git://people.freedesktop.org/~danvet/drm-intel
> > > 
> > > Hmm, actually not. Either drm-intel-fixes branch, or Linus' master.
> > 
> > Confirmed, the drm-intel-fixes branch from Daniel's tree
> > (3.7.0-rc2-00031-g1623392) works fine for me.
> > 
> > Do you know which commit(s) are likely to have fixed the problem, so we
> > can cherry pick the appropriate fix(es) to the 3.6.x tree?

Well, we know for sure that fdi link training is broken - it doesn't match
at all what the spec says we should do. I've been working on this lately,
since in quite a few circumstances the link train fails without the
relevent bits indicating so. While testing I've also noticed that this
entire thing is highly timing dependent, e.g. denpending upon which
desktop is running and which tool I use to change the configuration it
fails or succeeds.

So I have no suggestions for what could help your system and what should
get backported, since the current code is still broken.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
