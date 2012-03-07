Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab2CGSDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:03:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437Ab2CGSDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:03:39 -0500
MIME-Version: 1.0
In-Reply-To: <aefc95$3e4riv@orsmga001.jf.intel.com>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
 <1331121050-17857-3-git-send-email-djkurtz@chromium.org> <aefc95$3e4riv@orsmga001.jf.intel.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 8 Mar 2012 02:03:14 +0800
X-Google-Sender-Auth: NyEqP_b0CXAAvypU0q9g5SOc1AU
Message-ID: <CAGS+omBpUoyrrtjA9SwZmKaLct0YTYSZt01Hs5KsyZZBqxgiBg@mail.gmail.com>
Subject: Re: [PATCH 2/9] drm/i915/intel_i2c: assign HDMI port D to pin pair 6
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> On Wed,  7 Mar 2012 19:50:43 +0800, Daniel Kurtz <djkurtz@chromium.org>
> wrote:
> > According to i915 documentation [1], "Port D" (DP/HDMI Port D) is
> > actually gmbus pin pair 6 (gmbus0.2:0 == 110b GPIOF), not 7 (111b).
> > Pin pair 7 is a reserved pair.
> >
> > [1] Documentation for [DevSNB+] and [DevIBX], as found on
> > http://intellinuxgraphics.org
>
> The problem is I took those definitions from the gen2 specs, and munged
> in the obvious changes with gen3... And it appears that the GPIO pin
> assignment versus GMBUS has changed over the years. And so the can of
> worms is opened!

I'm not sure what exactly you mean by gen2 and gen3 specs, but, as far
as I can tell, the GPIO pin assignment is the same for both Cougar
Point (Sandy Bridge) [1] and Ibex Peak (?) [2].  Although, the
documentation is a bit confusing and it is difficult to tell.

[1] http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
[2] http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf

What do you mean exactly by gen2 & gen3?  Can you point to docs?

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
