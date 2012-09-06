Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2IFOdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:33:02 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41976 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab2IFOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <5048A6B6.40307@canonical.com>
References: <5048A6B6.40307@canonical.com>
Date: Thu, 6 Sep 2012 16:33:00 +0200
Message-ID: <CADdNU4QLhn1qq2_POXZPA+DtYQS5zkmm9o=5GO00_HKZxpj24Q@mail.gmail.com>
Subject: Re: drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot
From: Jakob Bornecrantz <wallbraker@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: airlied@gmail.com, airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 3:35 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Dave - I couldn't find this patch in your git repo at
> git://people.freedesktop.org/~airlied/linux in the drm-next or drm-fixes
> branches.
>
> https://patchwork.kernel.org/patch/1379071/
>
> It appears to fix a real problem for Mac users -
> http://bugs.launchpad.net/bugs/1039157. See
> https://bugs.launchpad.net/ubuntu/oneiric/+source/linux/+bug/1039157/comments/31
> for confirmation.

Thanks, I was going to point out that Dave had already fix this, but it seem
you already knew about that. There is a companion patch along side with
the one mentioned.

http://lists.freedesktop.org/archives/dri-devel/2012-August/027124.html
http://lists.freedesktop.org/archives/dri-devel/2012-August/027125.html

I recommend applying both and turning the config to yes (as long as you
have the kms enabled xf86-video-vmware driver installed). I RB:ed them
both along with the dumb ioctl interface here:

http://lists.freedesktop.org/archives/dri-devel/2012-August/027139.html

>
> I think it should also be 'Cc: stable@vger.kernel.org'. It applies as
> far back as 2.6.32 with minor context differences.
>
> rtg

Its probably safe, but it could mean that the driver gets loaded on
distros, where in the past it hasn't tho that should be safe.

Cheers, Jakob.
