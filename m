Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2EaOnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:43:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52538 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2EaOnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120530222651.GA22449@redhat.com>
References: <20120530213128.GA10407@redhat.com>
	<CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
	<20120530215848.GB19223@redhat.com>
	<20120530222651.GA22449@redhat.com>
Date: Thu, 31 May 2012 11:43:21 -0300
Message-ID: <CA+gsUGRwNh9Zc9bA9JjdHSxpq7djLzqXdhAjcyCb2VcL7H+G_w@mail.gmail.com>
Subject: Re: Lots of i915/drm spew on 3.4
From: Paulo Zanoni <przanoni@gmail.com>
To: Dave Jones <davej@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/30 Dave Jones <davej@redhat.com>:
> On Wed, May 30, 2012 at 05:58:48PM -0400, Dave Jones wrote:
>  > On Wed, May 30, 2012 at 11:51:54PM +0200, Daniel Vetter wrote:
>  >  > On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
>  >  > > On this hardware:
>  >  > >
>  >  > > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
>  >  > >
>  >  > > I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)
>  >  >
>  >  > Just a quick question, is this a regression?
>  >
>  > seems so, I don't see it on 3.3
>  >
>  >  > If so, can you please
>  >  > attach the output of xrandr --verbose from a noisy and a quite kernel
>  >  > (otherwise just please attach it from this noisy kernel).
>  >
>  > this machine runs headless, so has no X installed right now, I'll get it in a while.
>
> Attached.
>

Just a little more information: you have a lot of connector properties
because for some reason the driver thinks you have TV1, TV2 and TV3.
Each TV connector has a lot of properties... With kernel 3.3 you have
only TV1 and TV2. Maybe instead of increasing the maximum property
count we should try to investigate why there's a new TV connector in
the new kernel (and maybe this is also not a bug/regression...).


-- 
Paulo Zanoni
