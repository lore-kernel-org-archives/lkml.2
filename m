Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1IPSKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:10:44 -0400
Received: from solo.fdn.fr ([80.67.169.19]:46114 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1IPSKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:10:43 -0400
Date: Fri, 16 Sep 2011 20:10:40 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20110916181040.GD4698@type.famille.thibault.fr>
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

Ah, actually home's success was a luck. I'm still getting random
failures at home too.

Samuel
