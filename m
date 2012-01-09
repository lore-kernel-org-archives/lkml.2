Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2AICf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:35:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51524 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751731Ab2AICf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:35:57 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19PS3BUcdtPa6M+UYX/DujAH1hYHp6Kp9/sGIF9Tv
	VlZtfL/hhHN5qQ
Message-ID: <4F0A5284.7080009@gmx.de>
Date: Mon, 09 Jan 2012 02:35:48 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/6] video: s3c-fb: Use runtime suspend while blanked
References: <20111227141550.GA3331@opensource.wolfsonmicro.com>
In-Reply-To: <20111227141550.GA3331@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 02:15 PM, Mark Brown wrote:
> This patch series (the first two of which I posted the other day)
> improves the runtime power management in the s3c-fb driver by moving it
> to keeping the device runtime suspended when the screen is powered down
> by userspace.  This saves a trivial amount of power in the framebuffer
> controller and allows the SoC core code to enter system wide idle
> states which offer much more substantial gains.
> 
> Currently it's only lightly tested but it certainly seems to the right
> thing for me.

Applied all 6 patches of this series.


Thanks,

Florian Tobias Schandinat

> 
> Mark Brown (6):
>       video: s3c-fb: Make runtime PM functional again
>       video: s3c-fb: Use s3c_fb_enable() to enable the framebuffer
>       video: s3c-fb: Disable runtime PM in error paths from probe
>       video: s3c-fb: Take a runtime PM reference when unblanked
>       video: s3c-fb: Hold runtime PM references when touching registers
>       video: s3c-fb: Don't keep device runtime active when open
> 
>  drivers/video/s3c-fb.c |  127 ++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 92 insertions(+), 35 deletions(-)
> 
> 

