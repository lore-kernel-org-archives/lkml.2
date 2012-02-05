Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2BEDGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 22:06:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50914 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab2BEDF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 22:05:59 -0500
MIME-Version: 1.0
In-Reply-To: <20120204114101.28b90fdf@pyramind.ukuu.org.uk>
References: <85aa4zs1q8.fsf@gmail.com>
	<20120204114101.28b90fdf@pyramind.ukuu.org.uk>
Date: Sat, 4 Feb 2012 22:05:58 -0500
Message-ID: <CAOQxz3x=FYKJJA8LdDwLMBi0VNDvVO5OD--X2G=jTGqFxUM_gg@mail.gmail.com>
Subject: Re: gma500: invalid frequency for monitor
From: Michael Labriola <michael.d.labriola@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, David Airlie <airlied@linux.ie>,
        Michael D Labriola <mlabriol@gdeb.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/12, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
*snip*
>> I think my setup is correct, because the vesa frambuffer seems to work
>> correctly.  All is well unless I load the gma500_gfx driver and let it
>> set the mode.
>
> What mode is the vesa driver using and if you set the same mode what
> happens ?

The vesa driver was using a resolution of 1280x1024x32... is there a
way to get a whole modeline out of that?

*snip*
>> [  110.586242] [drm:drm_helper_probe_single_connector_modes],
>> [CONNECTOR:7:LVDS-1] probed modes :
>> [  110.586274] [drm:drm_mode_debug_printmodeline], Modeline 10:"1280x1024"
>> 40 71500 1280 1328 1440 1688 1024 1025 1028 1072 0x8 0x0
>
> And we probed a 1280x1024 mode with a clock of 71.5 (which might be a bit
> high for the panel ?)

I'm assuming the clock is at fault, yes.

*snip*
>
> Do you have a different monitor around to try and also hand setting lower
> modes ?

Compiling on my home system overnight (these atom boards are pretty
slick, but slow as dirt at compiling the kernel).  I've got a
different monitor at home to try, so we'll see what happens.  How do I
hand set the mode that gma500 uses?
