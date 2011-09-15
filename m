Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1IOHlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:41:14 -0400
Received: from solo.fdn.fr ([80.67.169.19]:58646 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1IOHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:41:13 -0400
Date: Thu, 15 Sep 2011 09:41:06 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20110915074106.GA4544@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110914232717.GA5410@type.famille.thibault.fr>
 <yunobym743b.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yunobym743b.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard, le Thu 15 Sep 2011 00:43:36 -0500, a écrit :
> On Thu, 15 Sep 2011 01:27:17 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> Non-text part: multipart/mixed
> > Hello,
> > 
> > I'm trying to upgrade from 3.0 to 3.1-rcsomething on a DELL latitude
> > E6420, but dual head is broken. Here is the scenario:
> > 
> > - Turn computer on with VGA1 connected. Both LVDS1 and VGA1 show the
> >   text console fine.
> > - Start X. VGA1 shows X fine, but LVDS1 (1600x900 resolution) shows an
> >   odd screen: completely black on the left part (about 1060x900), sort
> >   of gray on the right part (about 540x900). Playing with xrandr doesn't
> >   help, I can at best make it completely black with --off, and not get
> >   it back again with --auto or anything else.
> 
> Can you try disabling frame buffer compression?
> 
> i915.i915_enable-fbc=0
> 
> I'm about to send a patch to disable this by default; I've gotten two
> people saying that this helps them already.

Absolutely. I have no issue any more, and the error messages are gone.

Samuel
