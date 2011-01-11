Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1AKQLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:11:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34035 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab1AKQLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f15au5spwDZttB7DE2mcM42F7m0AAAr3fz1VOr2EMbDPsBnRWVg/s5y7GP3ccJkDQ7
         MgUNBQASjk0AluIz0Jlh/yrcytFf2ETdioj0wAz9U+/viquf66smh3zZUuOonqxhfSVc
         zu3G1qfhxV1uEAdFZtuzIHdx1HJIUtVJAtD6w=
MIME-Version: 1.0
In-Reply-To: <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
Date: Tue, 11 Jan 2011 18:11:40 +0200
Message-ID: <AANLkTimx0hWByYw1dXKS6y0B9a84gYOxBu-Gnjm+cCwa@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 6:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 10, 2011 at 10:06 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> Arg.  It's been ok on my ILK systems, but Chris has found some issues with out watermarking code iirc; apparently we're underflowing the display FIFO, causing all sorts of trouble.  If it works before the pull of Dave's tree, can you bisect?
>
> There's no way to bisect this thing - it started happening after 2
> hours (first message at 8287.139375 seconds from boot, to be exact).
> So far only once, but that's possibly because I've been asleep for the
> last eight hours ;)
>
> But yes, it worked before pulling Dave's tree, IOW, I haven't seen
> this message on this machine before.
>
> And as mentioned, this is a regular machine, not one of my
> preproduction things that tend to have odd silicon or BIOSes.
> Bog-standard Core i5 on an Asus P7H57D-V EVO motherboard. The fanciest
> part of that machine is the silent case ;)
>
> Chris wrote:
>> Linus, is anything else kicked off upon powersaving? A screen saver or is
>> it just the blanking that triggers the mess?
>
> So I don't _know_ that it was the screen saver that triggered, but I
> do know that it started happening while I was out to pick up a kid
> from gymnastics. So the screen saver was pretty much the only thing
> going on apart from an idle desktop with a few terminals and chrome.
>
> And it's not even a 3D screen saver or anything graphically fancy,
> it's just the "show random photos" one (it eventually does blank too,
> but I think I've set the blanking interval to an hour or something).
> But compiz was on.
>
>                         Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Linus, 2.6.37-git4 works for me, can you unpull the DRM, and wait
until is more stable ?
