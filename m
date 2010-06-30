Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0F3Q0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:26:45 -0400
Received: from lechat.rtp-net.org ([88.191.19.38]:53387 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F3Q0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:26:44 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2010 12:26:44 EDT
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
       Kukjin Kim <kgene.kim@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Abraham <thomas.ab@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 30/33] Removing dead S3C_DEV_ADC
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<7baaebb4983ce9482e3f83ca42240b864157cb79.1277911346.git.siccegge@cs.fau.de>
Organization: RtpNet
Date: Wed, 30 Jun 2010 18:24:20 +0200
In-Reply-To: <7baaebb4983ce9482e3f83ca42240b864157cb79.1277911346.git.siccegge@cs.fau.de> (Christoph Egger's message of "Wed\, 30 Jun 2010 18\:03\:26 +0200")
Message-ID: <876310pjyj.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger <siccegge@cs.fau.de> writes:

> S3C_DEV_ADC doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  arch/arm/mach-s5pv210/cpu.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-s5pv210/cpu.c b/arch/arm/mach-s5pv210/cpu.c
> index 411a4a9..c5d53ab 100644
> --- a/arch/arm/mach-s5pv210/cpu.c
> +++ b/arch/arm/mach-s5pv210/cpu.c
> @@ -76,10 +76,6 @@ static void s5pv210_idle(void)
>  
>  void __init s5pv210_map_io(void)
>  {
> -#ifdef CONFIG_S3C_DEV_ADC
> -	s3c_device_adc.name	= "s3c64xx-adc";
> -#endif
> -

too bad, should have been SAMSUNG_DEV_ADC :(
Anyway, a patch called "[PATCH] ARM: SAMSUNG: Implement set_name
function for ADC devices" has been sent for review today and is
addressing this same issue.

Thanks,
Arnaud
