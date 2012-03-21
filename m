Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2CURrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:47:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2CURrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQKjZOG7c3OjCVCzwF2qWRNQdmj=DdQSAgnX5sFPAL5JuinBg@mail.gmail.com>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
	<CAAQKjZOG7c3OjCVCzwF2qWRNQdmj=DdQSAgnX5sFPAL5JuinBg@mail.gmail.com>
Date: Wed, 21 Mar 2012 17:47:35 +0000
Message-ID: <CAPM=9txsTTyEaCM3Jas_WyXPCS0wgXttfFuUhQ6_6kn90t=MtA@mail.gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
From: Dave Airlie <airlied@gmail.com>
To: InKi Dae <daeinki@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 5:31 PM, InKi Dae <daeinki@gmail.com> wrote:
> Hi Linus,
>
> now mainline has a duplicated patch set for exynos drm driver so
> please revert the patch below from mainline before merging with
> drm-next to avoid conflict.
> subject: drm exynos: use drm_fb_helper_set_par directly
> commit id: 34418c25d64844625118b5eedc493f7904d77659
>
> this patch had already been included in Dave's drm-next. I am sorry to trouble.

Inki it shouldn't be a problem, Linus can resolve conflicts fine. If
there is any.

Dave.
