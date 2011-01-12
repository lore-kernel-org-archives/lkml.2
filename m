Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab1ALByg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:54:36 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46488 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1ALByd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t/OJRDNPwje2dWRsQ2B4ggdIGPk+oNncFCmMqGFmezBZN/97axVkiRCqIzhfTZowW/
         fYoZ9ACxXYmpcCSi6k66CrEsUDXZzhzuLnO15hVXszS9baoRLuEdGAVW0fvorXdYM2hx
         1FWyFuuhmwxVa5+7plDzJB/rG71TkcugI+HCI=
MIME-Version: 1.0
In-Reply-To: <AANLkTin1E6A8Mc9W3z9JpY4kZwNC6mJ1g1H-HMD5FRRh@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
	<AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
	<20110111111203.279eae50@jbarnes-desktop>
	<AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
	<AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
	<AANLkTinpy-Qm3kHuGtdviVmw4oRO95AN3DmSGfoz+YHT@mail.gmail.com>
	<AANLkTin1E6A8Mc9W3z9JpY4kZwNC6mJ1g1H-HMD5FRRh@mail.gmail.com>
Date: Wed, 12 Jan 2011 11:54:32 +1000
Message-ID: <AANLkTikS0CnHv6fN7bGw0CP8SxY5hNyGbppSA53_CveA@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 11:36 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 11, 2011 at 3:01 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>  ... I'll test that drm-intel-staging commit.
>
> Initial testing _seems_ to confirm that merging drm-intel-staging gets
> rid of the problem. But I haven't spent a whole lot of time in the
> screen saver. Will start driving kids around now, so more intense
> screen saver testing is coming up..

Its looking good here, I've pushed a drm-fixes branch with what Chris
sent me + a couple of i915/iommu fixes to my repo,

I'm going to run it on my laptop for a few more hours then I'll send
you a pull req, but none of the triggers I had yesterday seem to take
it down.

Dave.

>
>                   Linus
>
