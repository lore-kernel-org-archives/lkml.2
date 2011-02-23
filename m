Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1BWX6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:58:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab1BWX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:58:53 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 15:58:02 -0800
Message-ID: <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Indan Zupancic <indan@nul.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 3:17 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> Nothing too major,
>
> Two regression fixers (one revert that got fixes properly elsewhere), some
> timestamp fixes and an agp module reload fix.

Pulled. However, what about the report from	Pavel Machek <pavel@ucw.cz>:

> >      drm/i915: Completely disable fence pipelining.
>
> Reverting this commit helps in v2.6.38-rc5+ when screen is not fully updated,
> or has a corrupted picture like horizontal black or white stripes. Using a
> compositor like compiz may help to avoid the problem.
>
> See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572

Any update on that one? There's that whole "return -EINVAL for
I915_PARAM_HAS_RELAXED_FENCING" patch thing?

                 Linus
