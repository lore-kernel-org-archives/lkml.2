Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2AEKC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:02:56 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:21912
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752743Ab2AEKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:02:55 -0500
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jan 2012 05:02:55 EST
X-IronPort-AV: E=Sophos;i="4.71,461,1320620400"; 
   d="scan'208";a="125661992"
Date: Thu, 5 Jan 2012 10:53:01 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in
 3.1-rc*
Message-ID: <20120105095301.GA4504@type.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110914232717.GA5410@type.famille.thibault.fr>
 <yunobym743b.fsf@aiko.keithp.com>
 <20110915074106.GA4544@type.famille.thibault.fr>
 <20110915081259.GB4877@type.bordeaux.inria.fr>
 <yunlitp7umf.fsf@aiko.keithp.com>
 <20110916163050.GT4891@type.bordeaux.inria.fr>
 <20120105021646.GA4099@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120105021646.GA4099@type.famille.thibault.fr>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Thu 05 Jan 2012 03:16:46 +0100, a écrit :
> Samuel Thibault, le Fri 16 Sep 2011 18:30:50 +0200, a écrit :
> > Keith Packard, le Thu 15 Sep 2011 09:22:48 -0500, a écrit :
> > > On Thu, 15 Sep 2011 10:12:59 +0200, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > > 
> > > > At home only. At work, with a different VGA screen, I'm still getting
> > > > the issue.
> > > 
> > > You're still having a problem with the LVDS screen at work with FBC
> > > disabled?
> > 
> > Yes, though it now seems random, sometimes it works, sometimes not.
> 
> I have just tried a fresh 3.2 once, without problem. Within a few days,
> I'll know whether it's luck or magical-fixup.

It didn't take long. I'm still randomly getting the issue.

Samuel
