Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2DBDkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:40:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2DBDkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:40:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
	<CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
Date: Mon, 2 Apr 2012 12:40:39 +0900
X-Google-Sender-Auth: 0auCsR9CM-nHx8MF5PpwwrMUWBU
Message-ID: <CAH9JG2VujPUQfJ=7nyqM90jzuf60qqNYVi4fN40F1SpDua75gg@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Kyungmin Park <kmpark@infradead.org>
To: Rob Clark <rob.clark@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linaro-dev@lists.linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 12:34 AM, Rob Clark <rob.clark@linaro.org> wrote:
> On Sat, Mar 31, 2012 at 6:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>  - drm dma-buf prime support. Dave Airlie sent me the pull request but
>> didn't push very hard for it, it's in my "ok, I can still pull it for
>> 3.4 if individual DRM driver people tell me that it will make their
>> lives easier." So this is in limbo - I have nothing against it, but I
>> won't pull unless I get a few people say "yes, please".
>
> yes, please :-)
>
> Note that the core drm dma-buf/prime support has already been reviewed
> by a lot of folks, and tested with a few different drivers (exynos,
> omapdrm, i915, nouveau, udl) with some driver support that could be
> pushed for 3.5 cycle if the core support makes it in for 3.4 cycle.
Yes, Please.

It's used for exynos display and multimedia.

Thank you,
Kyungmin Park
>
> BR,
> -R
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
