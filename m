Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0F3ID4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:03:56 -0400
Received: from smtp-out-153.synserver.de ([212.40.180.153]:1044 "HELO
	smtp-out-153.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751736Ab0F3IDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:03:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 5567
Date: Wed, 30 Jun 2010 10:03:51 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm fixes + agp + one fb patch
Message-ID: <20100630080351.GB1722@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
 <20100630065440.GA1736@arch.tripp.de>
 <AANLkTimXZ4gd9JtF0i0rXFnY8s4iRazKGbPgH4lhCDbS@mail.gmail.com>
 <AANLkTikxNWaLeVcdn-8kBwZt_toMmuGJO3seOsEdHwyq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikxNWaLeVcdn-8kBwZt_toMmuGJO3seOsEdHwyq@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:00:32PM +1000, Dave Airlie wrote:
> On Wed, Jun 30, 2010 at 5:57 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Wed, Jun 30, 2010 at 4:54 PM, Markus Trippelsdorf
> > <markus@trippelsdorf.de> wrote:
> >> On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
> >>>
> >>> Hi Linus,
> >>>
> >>> one fb layer fix in a flag I introduced,
> >>>
> >>> the rest are drm fixes:
> >>> radeon fixes: the larger ones in the command stream checker for older cards,
> >>> which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
> >>> along with some updates to the evergreen command stream checker introduced in -rc1.
> >>>
> >>> agp: fix issue with warning on memory allocation + fallback to vmalloc.
> >>> ttm: fix regression introduced in -rc1 in memory allocation paths.
> >>>
> >>> The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
> >>>
> >>>   Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
> >>>
> >>
> >> I've tested these patches and they break my setup (RS780). On reboot, the
> >> monitor goes straight to powersaving mode and no framebuffer is shown.
> >
> >  Can you bisect which one does it? 2.6.35-rc3 works okay?
> 
> first guess is 6d35ce0a468b8098c22ca54b4e222c27e364f9bb
> then 8ed219f50c943a21a0b4f545876b58a344a28f45
> then d2c1736971e3cc3b5315d034424a872dc5f44f4a

It's 07d4190327b02ab3aaad25a2d168f79d92e8f8c2 :-)
see my other email.

-- 
Markus
