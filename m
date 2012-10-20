Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2JTJ0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 05:26:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2JTJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 05:26:53 -0400
Date: Sat, 20 Oct 2012 11:26:47 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121020092647.GA3186@fancy-poultry.org>
References: <1724445.dN2yMEzN6d@localhost>
 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:AFOOJdTYetjrOqz04rkRGzChncwVlMUkQH2XkR9Pn2i
 XMZY3m8aglOaPi1f8yDJL2dHBw200TKVQNHD7LJWc78t9bbGtw
 IUNdas4fRJ0+fX7FD3DAzrmSgN5vfpayweM9dgIoL4aTW5sF8J
 SmkeQ8vE047+flJ7ZnEtsTsUkMCVluHl9OLuWT/OUwepX84lCo
 4CvQ6/l0/jqPJXuJeER/D1s8cEJFAd1TqRDWE+meuRcxHjBrAl
 dF7Ey+Yx7IWtM02lkcpynulgqNggwe/Z1J4UHHUOhlP72FCzEA
 9hEjixCLvZSJldOzmcn+0BJ0li1mJsUEUibqueG9dhH/yIpySe
 Sux019Wa8SVeIkDaBV+kFF4WOgO73rnacmGKYG2+w
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2012, Linus Torvalds wrote:

> Added more appropriate people to this. Added both i915 and nouveau
> people, since apparently that fine piece of hardware has both.
>
> Guys, any ideas?

Plese see https://lkml.org/lkml/2012/10/19/371 , this is the same
thing going on. Reverting

 Ben Skeggs <bskeggs@redhat.com>
 drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB

fixes the problem.

