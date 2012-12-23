Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2LWMWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 07:22:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35835 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab2LWMWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 07:22:17 -0500
Date: Sun, 23 Dec 2012 13:22:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223122210.GA4460@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Andy Furniss <andyqos@ukfsn.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20121222203547.GA5319@liondog.tnic>
 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
 <20121223002507.GA12121@liondog.tnic>
 <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
 <20121223105527.GA6230@liondog.tnic>
 <50D6E491.3030801@ukfsn.org>
 <20121223110730.GC6230@liondog.tnic>
 <50D6E8A4.1030204@ukfsn.org>
 <20121223113153.GA8918@liondog.tnic>
 <20121223115133.GA229@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121223115133.GA229@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 12:51:33PM +0100, Markus Trippelsdorf wrote:
> (If you don't use modules: git grep MODULE_PARM_DESC --
> drivers/gpu/drm/radeon/ )

Yeah.

> You may have hit the same issue as I, see:
> http://thread.gmane.org/gmane.comp.video.dri.devel/78328

Yes, it very much looks like it. That same page kills the machine here
too. Maybe the GPU gets scared from the graphic nature of those images
and gives up. :-D

Although the box is not completely dead - I can login to a console and
save dmesg before rebooting.

And this bug becomes funnier and funnier - Alex, you might want to add
that webpage to your testsuite :-).

> Reverting commit 2d6cc729 fixes the problem for me, setting
> radeon.no_wb=1 doesn't help.

Right, let me try that and report back.

Good job Markus, thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
