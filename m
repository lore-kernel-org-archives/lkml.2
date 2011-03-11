Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1CKJXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:23:55 -0500
Received: from cable-static-216-94.intergga.ch ([87.102.216.94]:38449 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab1CKJXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:23:52 -0500
X-Spam-ASN: 
X-Spam-Spammy: 0.965-+--H*r:mail.ffwll.ch, 0.941-+--H*Ad:D*ffwll.ch,
	0.941-+--H*Ad:U*daniel.vetter
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Fri, 11 Mar 2011 10:23:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Indan Zupancic <indan@nul.nu>
Cc: Daniel Vetter <daniel@ffwll.ch>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: fix corruptions on i8xx due to relaxed
 fencing
Message-ID: <20110311092331.GA4897@viiv.ffwll.ch>
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	dri-devel@lists.freedesktop.org,
	LKML <linux-kernel@vger.kernel.org>
References: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
 <1298395549-4064-1-git-send-email-daniel.vetter@ffwll.ch>
 <ed85db84d2d5ea460898d78e1179c6ca.squirrel@webmail.greenhost.nl>
 <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
 <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
 <8b77a7a0de898635c8b25e7612907deb.squirrel@www.ffwll.ch>
 <2e9ca0040729649ed989a16a07bb2c49.squirrel@webmail.greenhost.nl>
 <a43587d716af46c642fe30e779204ca0.squirrel@www.ffwll.ch>
 <0f66fbcc9c86ced2cfe625395de31835.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f66fbcc9c86ced2cfe625395de31835.squirrel@webmail.greenhost.nl>
X-Operating-System: Linux viiv 2.6.38-rc5-00035-g3077686 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 02:08:46AM +0100, Indan Zupancic wrote:
> On Thu, March 10, 2011 14:31, Daniel Vetter wrote:
> > Am Do, 10.03.2011, 11:36 schrieb Indan Zupancic:
> >> Which versions fix this, just for reference?
> >
> > git master branch of libdrm and xf86-video-intel newer than 2011-02-22.
> 
> Thank you. If there will be no new releases of those packages within
> a couple weeks it might be better to temporarily add those checks back
> for gen 2 only, I think. Otherwise there will be a period where people
> who update regularly will have screen corruption, with no easy way of
> fixing it. I think this would avoid a few unnecessary bugreports. The
> check can be removed in 2.6.39-rc1, if you want I'll remind you about
> it too.

Well, libdrm is already released (2.4.24) and for the ddx there's an rc
(2.4.901) out there. So that should be sufficient.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
