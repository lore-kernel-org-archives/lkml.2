Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2LDM46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 07:56:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38288 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2LDM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:56:57 -0500
Date: Tue, 4 Dec 2012 13:58:23 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Heinz Diehl <htd@fritha.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        Heinz Diehl <htd@fancy-poultry.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121204125823.GC11556@phenom.ffwll.local>
Mail-Followup-To: Heinz Diehl <htd@fritha.org>,
	Dave Airlie <airlied@gmail.com>,
	Heinz Diehl <htd@fancy-poultry.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
 <20121204083655.GA21235@fancy-poultry.org>
 <CAPM=9twQZUWBf9FZdAwz5NuaTvfgJSA=bjgHq9rpTMMU3ABRVw@mail.gmail.com>
 <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
 <20121204123522.GA32419@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204123522.GA32419@fritha.org>
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 01:35:22PM +0100, Heinz Diehl wrote:
> On 04.12.2012, Daniel Vetter wrote: 
> 
> > Yeah, if anyone can somewhat reliably reproduce this
> 
> Ok, I see. So the beginning would be to reliably reproduce the the
> hang. I have encountered it in any possbile situasjon, both when
> watching videos on Youtube and right after booting the machine and
> doing absolutely nothing.
> 
> I'll try around a little bit and see if I can find something that
> triggers this hang. 
> 
> Btw: which kernel is known to be the "last good one"?

If it's the ilk one we only know that 3.6.x series seems to be solid, and
something in 3.7-rc (probably before -rc1) broke stuff. So not too useful.

> > (you need to disable rc6 on ilk to not hit another issue which seems much easier to
> > hit) 
> 
> Ilk? If this stands for "Ironlake": I'm on Sandybridge.

Hm, then it could very well be something different, so I think we need to
track this one as a separate bug. Can you please file a new one on
bugs.freedesktop.org against DRI -> DRM (Intel) and attach dmesg when
booting with drm.debug=0xe (just so we know what's in your box) plus the
i915_error_state from debugfs once the gpu is hung (if you can get at that
file, reboot kills it).

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
