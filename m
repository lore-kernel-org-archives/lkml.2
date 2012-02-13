Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2BMV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:27:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51640 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755973Ab2BMV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:27:31 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+Y6FI91JGYBOP3b5OdrLCJrodUv4Hui73zQLMsUM
	p6LEmm481eQZTl
Message-ID: <4F398033.80900@gmx.de>
Date: Mon, 13 Feb 2012 21:27:15 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: linux-fbdev@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: da8xx-fb: Fix build warning on unused label
References: <1328763879-16345-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1328763879-16345-1-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 05:04 AM, Manjunathappa, Prakash wrote:
> Patch fixes build warning on label "err_cpu_freq" when CONFIG_CPU_FREQ
> is not defined.
> 
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/da8xx-fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index 29577bf..f360d62 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -1264,8 +1264,8 @@ static int __devinit fb_probe(struct platform_device *device)
>  irq_freq:
>  #ifdef CONFIG_CPU_FREQ
>  	lcd_da8xx_cpufreq_deregister(par);
> -#endif
>  err_cpu_freq:
> +#endif
>  	unregister_framebuffer(da8xx_fb_info);
>  
>  err_dealloc_cmap:

