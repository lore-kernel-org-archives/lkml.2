Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab1AKXCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:02:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584Ab1AKXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:02:46 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
 <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
 <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
 <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
 <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
 <20110111111203.279eae50@jbarnes-desktop> <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
 <AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 15:01:53 -0800
Message-ID: <AANLkTinpy-Qm3kHuGtdviVmw4oRO95AN3DmSGfoz+YHT@mail.gmail.com>
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

On Tue, Jan 11, 2011 at 2:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll test the merge, but I thought I'd send out this note already at
> this point, because I'm pretty sure this is it.

Hmm. The merge already has the *ERROR* Hangcheck (together with jerky
behavior), so it wasn't actually the polling patch that turned the
BUG_ON() into a jerky experience. But I'll test that drm-intel-staging
commit.

          Linus
