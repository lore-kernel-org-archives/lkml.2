Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2AECWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:22:39 -0500
Received: from solo.fdn.fr ([80.67.169.19]:34260 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab2AECWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:22:34 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 21:22:34 EST
Date: Thu, 5 Jan 2012 03:16:46 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20120105021646.GA4099@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110914232717.GA5410@type.famille.thibault.fr>
 <yunobym743b.fsf@aiko.keithp.com>
 <20110915074106.GA4544@type.famille.thibault.fr>
 <20110915081259.GB4877@type.bordeaux.inria.fr>
 <yunlitp7umf.fsf@aiko.keithp.com>
 <20110916163050.GT4891@type.bordeaux.inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110916163050.GT4891@type.bordeaux.inria.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Fri 16 Sep 2011 18:30:50 +0200, a écrit :
> Keith Packard, le Thu 15 Sep 2011 09:22:48 -0500, a écrit :
> > On Thu, 15 Sep 2011 10:12:59 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > 
> > > At home only. At work, with a different VGA screen, I'm still getting
> > > the issue.
> > 
> > You're still having a problem with the LVDS screen at work with FBC
> > disabled?
> 
> Yes, though it now seems random, sometimes it works, sometimes not.

I have just tried a fresh 3.2 once, without problem. Within a few days,
I'll know whether it's luck or magical-fixup.

Samuel
