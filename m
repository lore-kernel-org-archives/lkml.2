Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2A2MMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:12:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62576 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2A2MMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:12:03 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120129044423.GA26244@localhost>
References: <20120109131717.GA4713@localhost>
	<86y5tgx02g.fsf@sumi.keithp.com>
	<20120110054519.GA27257@localhost>
	<86ty404yhd.fsf@sumi.keithp.com>
	<20120116080252.GA18538@localhost>
	<20120116202618.GG3627@phenom.ffwll.local>
	<86obu31io4.fsf@sumi.keithp.com>
	<20120116230809.GA7837@localhost>
	<20120117102203.GC4093@phenom.ffwll.local>
	<20120129044423.GA26244@localhost>
Date: Sun, 29 Jan 2012 13:12:02 +0100
X-Google-Sender-Auth: jbBGEjjmPfUNfgRtJuaPGkinodU
Message-ID: <CAKMK7uFSv=SO-a+4o8Nga75U6uOAp=TqUP6dU=-38n3ntxtdpQ@mail.gmail.com>
Subject: Re: [PATCH][rebased] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
From: Daniel Vetter <daniel@ffwll.ch>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Keith Packard <keithp@keithp.com>, Takashi Iwai <tiwai@suse.de>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 05:44, Wu Fengguang <fengguang.wu@intel.com> wrote:
> It should be programmed to "0" for HDMI or "1" for DisplayPort.
>
> This enables DisplayPort audio for
>
> - HP EliteBook 8460p
>  (whose BIOS does not set the N_value_index bit for us)
>
> - DisplayPort monitor hot plugged after boot
>  (otherwise most BIOS will fill the N_value_index bit for us)
>
> Tested-by: Robert Lemaire <rlemaire@suse.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |   12 ++++++++++++
>  drivers/gpu/drm/i915/intel_display.c |    8 +++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
>> I've tried to apply this patch but it has a conflict in i915_reg.h (with
>> the SOL reset stuff). Care to rebase and resend? Also, git patches as
>> produced by git format-patch highly preferred.
>
> Daniel, this is now based on linux-next. I use quilt, hope it also
> works for you :)

On a quick check this patch is missing the hunk to actually write the
aud configuration into the register. I presume that's not intentional,
so can you please resend?

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
