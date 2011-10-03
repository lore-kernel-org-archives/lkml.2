Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1JCKK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:10:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1JCKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:10:22 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <yund3eg5yea.fsf@aiko.keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-15-git-send-email-keithp@keithp.com>
	<20110930181644.GR2859@phenom.ffwll.local>
	<yunoby15qwu.fsf@aiko.keithp.com>
	<20111001095908.GB2807@phenom.ffwll.local>
	<yund3eg5yea.fsf@aiko.keithp.com>
Date: Mon, 3 Oct 2011 12:10:20 +0200
X-Google-Sender-Auth: 2HlQkhXMdaWgUdiM1XHmQN0xK7c
Message-ID: <CAKMK7uGXK=k58O2_5FRWpqiWy=eVtmRTQUphgu_0LU0rg_Ho2w@mail.gmail.com>
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay computations
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 21:01, Keith Packard <keithp@keithp.com> wrote:
> On Sat, 1 Oct 2011 11:59:09 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
>
>> So while you bang your head against this, can you add the backlight power
>> sequencing delays for lvds panels, too? The lvds panel power sequencing
>> should be imo safe - we just msleep-spin with wait_for until the power
>> sequencer has completed the request.
>
> That should be a separate patch set, probably by someone with a
> reasonable range of hardware to actually test it. Somehow I've managed
> to get rid of all of my non-PCH hardware...

Agreed, I've looked a bit at the lvds code and it's quite different,
backlight-wise. Btw, I also see backlight-not-lighting-up issues on
snb, so not only pre-pch-split. I'll look into this when your edp
fixes have settled.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
