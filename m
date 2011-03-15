Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1COIhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:37:11 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59594 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab1COIhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:37:08 -0400
Message-ID: <4D7F24E4.2040103@fastmail.fm>
Date: Tue, 15 Mar 2011 09:35:48 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, xorg-driver-ati@lists.x.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm>	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com> <AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
In-Reply-To: <AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1PzPjQ-0007JA-C4.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PzPjQ-0007JA-C4 bca258e0ee8d86d24545e83c9cfa3d9d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Does this patch help?
>
> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c
> b/drivers/gpu/drm/radeon/atombios_crtc.c
> index 1d89259..a2bd944 100644
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -524,7 +524,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
>                 if ((rdev->family == CHIP_RS600) ||
>                     (rdev->family == CHIP_RS690) ||
>                     (rdev->family == CHIP_RS740))
> -                       pll->flags |= (/*RADEON_PLL_USE_FRAC_FB_DIV |*/
> +                       pll->flags |= (RADEON_PLL_USE_FRAC_FB_DIV |
>                                        RADEON_PLL_PREFER_CLOSEST_LOWER);
>
>                 if (ASIC_IS_DCE32(rdev) && mode->clock > 200000)
>  /* range limits??? */

No. No improvement on rc8.
