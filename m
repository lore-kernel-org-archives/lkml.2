Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1CNWYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:24:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56535 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab1CNWYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ophirWphe7UDty65GqqJWZbW9a2TUpJ0hvNw4AxBsturGGFCvzzqsETfC/GNJ1Di5p
         nRctIvIgNDJwNUlDfr40YRuJpqTklspPevPU36hXHRlmAPJ/7iY/tlKg5fj+ziiF5+GP
         1rRtppt34A2cWQh4K/04XR6NPLaY+6pJ0mVF4=
MIME-Version: 1.0
In-Reply-To: <4D7CCFC3.7030906@fastmail.fm>
References: <4D7CCFC3.7030906@fastmail.fm>
Date: Mon, 14 Mar 2011 18:20:33 -0400
Message-ID: <AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>
Subject: Re: Radeon jittery post 2.6.35
From: Alex Deucher <alexdeucher@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 10:08 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>  Hi,
>
> I've found what I guess is a radeon (or drm/kms) regression post 2.6.35.
> I've got my TV conneced to my RS690G over HDMI, and the display has
> always been jittery after POST and at the GRUB screen. Pre-KMS, the X
> server (or driver got it sorted), and when KMS started, the display
> stabilized right after the kernel driver was initiated. However, post
> 2.6.35, I see the jitter is back.
>
> I've spent the last month trying to bisect it, but pretty much failed.
> It appears that versions closer to 2.6.38-rcX are more prone to display
> jitter, while 2.6.36 or so can have many successful runs. It also
> appears to be related to device power-on order, or so I've come to
> believe; A stable display can turn jittery, just by power cycling the TV.
>
> I've uploaded a video of a 38-rc8 boot:
> http://www.easy-share.com/1914220540/2.6.38-rc8_bad_x.mp4
>
> You'll see jitter at the POST screen and GRUB. When KMS kicks in it
> stabilizes, and when Freevo starts X, it's back to jitter.

Does plain X or gnome/kde jitter too or just freevo?

Alex

>
> The jitter is always of the same kind. It looks like an old tv set which
> loses sync. The contents on the display is, for a split second, placed
> at the wrong part of the screen (vertically and to some extent
> horizontally), and every 5-15 seconds or so, there is a big reset when
> the TV tries to restart things (I guess). At the resets, thee is a loud
> 'ping' in the nearby stereo too...
>
> During the bisect  (and a t 38-rc8) I've seen this both at the console
> (post KMS) and in X, so I'm not sure where the error is. I hope some of
> you can get a better idea of where to hunt for the bug by looking at the
> video.
>
> -Anders
>
