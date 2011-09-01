Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab1IANEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:04:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44208 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932107Ab1IANEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:04:39 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1//NUgOEyP/HXvDeSWpP94EkXr8KN11QdupZCERHQ
	VlxLVsxPgHmOKK
Message-ID: <4E5F82DE.2060207@gmx.de>
Date: Thu, 01 Sep 2011 13:04:30 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH RESEND] video: nuc900fb: remove include of mach/clkdev.h
References: <1314836018.2208.3.camel@phoenix>
In-Reply-To: <1314836018.2208.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 12:13 AM, Axel Lin wrote:
> Since commit aa3831cf9d29cfeaebd8c2169378b74111364487
> "ARM: Consolidate the clkdev header files",
> the header file arch/arm/mach-nuc93x/include/mach/clkdev.h is removed.
> 
> This patch fixes below build error:
> 
> drivers/video/nuc900fb.c:42:25: error: mach/clkdev.h: No such file or directory
> make[2]: *** [drivers/video/nuc900fb.o] Error 1
> make[1]: *** [drivers/video] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.
I'm wondering whether this build regression was unavoidable...


Thanks,

Florian Tobias Schandinat


> ---
>  drivers/video/nuc900fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
> index 0fff5978..37dd850 100644
> --- a/drivers/video/nuc900fb.c
> +++ b/drivers/video/nuc900fb.c
> @@ -39,7 +39,6 @@
>  #include <mach/regs-clock.h>
>  #include <mach/regs-ldm.h>
>  #include <mach/fb.h>
> -#include <mach/clkdev.h>
>  
>  #include "nuc900fb.h"
>  

