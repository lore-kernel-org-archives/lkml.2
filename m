Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab1AKT0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:26:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191Ab1AKT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <20110111111203.279eae50@jbarnes-desktop>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
 <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
 <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
 <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
 <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com> <20110111111203.279eae50@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 11:25:39 -0800
Message-ID: <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:12 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Have you tried reproducing it using xset dpms force off or similar?

That doesn't seem to do anything bad.

In fact, I think the second time it happened the screen never went
black - just the random photo thing was on. But no, forcing the screen
saver on doesn't do it either (ie pressing the "lock screen" icon and
waiting for a few pictures to cycle).

Maybe the screen just has to be inactive for a longer time: do you do
some dynamic "let's power things down if nothing is changing"?

                           Linus
