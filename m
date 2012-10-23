Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2JWGg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:36:27 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59520 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2JWGg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:36:26 -0400
Date: Tue, 23 Oct 2012 08:36:23 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] drm_kms_helper problems
Message-ID: <20121023083623.774f093e@pluto.restena.lu>
In-Reply-To: <5085C092.8020309@cfl.rr.com>
References: <508409FC.6080805@cfl.rr.com>
	<20121021165802.578d6d6b@neptune.home>
	<50843C83.8040801@cfl.rr.com>
	<20121021211817.58c6ccaf@neptune.home>
	<50853121.3040803@cfl.rr.com>
	<50858513.3070909@compro.net>
	<5085C092.8020309@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 17:54:26 Mark Hounschell wrote:
> Another interesting thing. I changed the boot file to only 
> "video=HDMI-A-1:e" and the monitor on the DVI port complains about the 
> resolution being to high. I then put the hdmi cable onto my dvi/hdmi 
> adapter and plug it into the DVI port and wala, a 1920 x 1080 desktop. So I 
> reboot with it in that configuration  and again comes up good connected to 
> the DVI connector.

So at least the EDID firmware now gets recognized and considered :)

> # xrandr
> Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
> VGA1 disconnected (normal left inverted right x axis y axis)
> HDMI1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 
> 708mm x 398mm
>     1920x1080      60.0*+   50.0     25.0     30.0     30.0     24.0
>     1680x1050      59.9
>     1680x945       60.0
>     1400x1050      59.9
>     1600x900       60.0
>     1280x1024      75.0     60.0
>     1440x900       59.9
>     1280x960       60.0
>     1366x768       60.0
>     1360x768       60.0
>     1280x800       74.9     59.9
>     1152x864       75.0
>     1280x768       74.9     60.0
>     1280x720       50.0     60.0
>     1024x768       75.1     70.1     60.0
>     1024x576       60.0
>     800x600        72.2     75.0     60.3     56.2
>     720x576        50.0
>     848x480        60.0
>     720x480        59.9
>     640x480        72.8     75.0     60.0     59.9     59.9
>     720x400        70.1
> DP1 disconnected (normal left inverted right x axis y axis)
> HDMI2 disconnected (normal left inverted right x axis y axis)
> HDMI3 disconnected (normal left inverted right x axis y axis)
> DP2 disconnected (normal left inverted right x axis y axis)
> DP3 disconnected (normal left inverted right x axis y axis)
> 
> I'm still getting the same messages spewed into the kernel log file. So 
> this looks to me like the kernel is confused. Again, I ask, why do I have 3 
> HDMIs and 3 DPs but just one VGA.

Maybe Daniel or Chris can comment on that high quantity of DP/HDMI
connectors seen by driver. Those are probably also the cause of the
persistent EDID complaints in kernel log.


You could maybe try to disable those outputs in xorg.conf in order to not
get your log filled with bad EDID complaints for "unused" connectors.
But as specifying the EDID as firmware it's just a work-around to the
issue.

Bruno

> Something is just not right here. I'm beginning to think it's not me.
>
> Mark
