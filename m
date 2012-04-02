Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2DBMb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:31:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45646 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2DBMb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
	<CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
Date: Mon, 2 Apr 2012 08:31:57 -0400
Message-ID: <CADnq5_PKyEZim-0bGqHjiP1X8-YqUd0_JTu1VaHUfufqroYGJQ@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Alex Deucher <alexdeucher@gmail.com>
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

On Sun, Apr 1, 2012 at 11:34 AM, Rob Clark <rob.clark@linaro.org> wrote:
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

Please.  It's the first step in making hybrid laptops work properly in Linux.

Alex
