Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677Ab2BNOiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:38:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60115 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2BNOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:38:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.1202140305030.23763@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1202140305030.23763@frira.zrqbmnf.qr>
Date: Tue, 14 Feb 2012 09:38:13 -0500
Message-ID: <CADnq5_N-W-jwN+dx6bF5fOvGUeN3-oZ7U_sTvPF18q7bgGuOsw@mail.gmail.com>
Subject: Re: drm/radeon: white screen after X does modeswitch from KMS con
From: Alex Deucher <alexdeucher@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Alex Deucher <alexander.deucher@amd.com>, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 9:29 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> Hello,
>
>
> the SONY PCG U3 device has a
>
> 00:0c.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon
> Mobility M6 LY [1002:4c59]
>
> graphics card. With linux 3.1.10, X.org server 7.6_1.10.4 and
> xf86-video-ati-6.14.2, switching from KMS'd console to X on tty7
> yields a white screen that also stays when attempting to back to
> tty1.
>
> I have to boot with nomodeset to get a usable Xorg picture.
> Is it just that radeon_drv does not work together with KMS?

It should work fine.  Does it work any better with a newer kernel?  Is
this a regression?  If so, what was the last kernel that was working
properly? Please file a bug:
https://bugs.freedesktop.org
and attach your xorg log and dmesg output.

Alex
