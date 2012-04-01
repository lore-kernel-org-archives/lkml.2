Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2DAPfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:35:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46042 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2DAPe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:34:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
Date: Sun, 1 Apr 2012 10:34:58 -0500
Message-ID: <CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Rob Clark <rob.clark@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 6:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  - drm dma-buf prime support. Dave Airlie sent me the pull request but
> didn't push very hard for it, it's in my "ok, I can still pull it for
> 3.4 if individual DRM driver people tell me that it will make their
> lives easier." So this is in limbo - I have nothing against it, but I
> won't pull unless I get a few people say "yes, please".

yes, please :-)

Note that the core drm dma-buf/prime support has already been reviewed
by a lot of folks, and tested with a few different drivers (exynos,
omapdrm, i915, nouveau, udl) with some driver support that could be
pushed for 3.5 cycle if the core support makes it in for 3.4 cycle.

BR,
-R
