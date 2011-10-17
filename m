Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1JQStI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:49:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34184 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1JQStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:49:07 -0400
Date: Mon, 17 Oct 2011 20:49:51 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Problems with videos and i915 driver
Message-ID: <20111017184951.GK2971@phenom.ffwll.local>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <1318788068.12224.125.camel@gandalf.stny.rr.com>
 <20111017085546.GB2971@phenom.ffwll.local>
 <1318851627.12224.135.camel@gandalf.stny.rr.com>
 <20111017170218.GH2971@phenom.ffwll.local>
 <1318871219.12224.138.camel@gandalf.stny.rr.com>
 <20111017175258.GJ2971@phenom.ffwll.local>
 <1318875562.4722.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318875562.4722.4.camel@gandalf.stny.rr.com>
X-Operating-System: Linux phenom 3.0.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:19:22PM -0400, Steven Rostedt wrote:
> On Mon, 2011-10-17 at 19:52 +0200, Daniel Vetter wrote:
> > On Mon, Oct 17, 2011 at 01:06:59PM -0400, Steven Rostedt wrote:
> > > It's running Fedora 14, and I rather avoid Gnome3 and systemd, which
> > > prevents me from moving her to Fedora 15. If F14 does not provide the
> > > necessary updates, I'll move her over to a Debian system.
> > 
> > Generally we're (unfortunately) only now cracking down on a few
> > long-standing Sandybdrige gpu hang issues, so you want something that
> > tracks upstream (and sometimes even git master) pretty closely.
> > 
> 
> What git tree is this? I could try it out.

Just for these fixes you'd need libdrm and xf86-video-intel. Git repos for
these two:

git://anongit.freedesktop.org/git/xorg/driver/xf86-video-intel
git://anongit.freedesktop.org/git/mesa/drm

See

http://intellinuxgraphics.org/download.html

for the entire stack.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
