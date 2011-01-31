Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1AaLXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:23:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40069 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1AaLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:23:41 -0500
Date: Mon, 31 Jan 2011 11:23:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        lrg@slimlogic.co.uk
Subject: Re: [alsa-devel] [PATCH] soc: neo1973_wm8753 audio support does
	not require scoop
Message-ID: <20110131112339.GD11937@sirena.org.uk>
References: <201101281200.18371.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101281200.18371.hartleys@visionengravers.com>
X-Cookie: To err is humor.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 12:00:18PM -0700, H Hartley Sweeten wrote:
> This driver does not use any of the functionality provided by the scoop
> hardware.  Remove the unneeded header.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

CCing in Liam.  As I think I've mentioned before please do remember to
CC maintainers.

> 
> ---
> 
> diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
> index c7a2451..c5b3113 100644
> --- a/sound/soc/samsung/neo1973_wm8753.c
> +++ b/sound/soc/samsung/neo1973_wm8753.c
> @@ -24,7 +24,6 @@
>  #include <sound/tlv.h>
>  
>  #include <asm/mach-types.h>
> -#include <asm/hardware/scoop.h>
>  #include <mach/regs-clock.h>
>  #include <mach/regs-gpio.h>
>  #include <mach/hardware.h>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
