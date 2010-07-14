Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0GNMaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:30:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37834 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0GNMao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xk3iPmLeUE6D9xoC1OZ+xiNEqrdRvVk6Up7LLZFMxrUMO0ILgL3IwYi4nTXnTjn/9w
         ItVHi4WasvCvkGbhJgha9XP8wP5yMFsS9AC5s7K4EaTySrTAfGHAAP+e0sM88iYC1/K8
         4CDuI8v3JQL6rjL+/Ce3XIdyxjSNFHVBex7Nc=
MIME-Version: 1.0
In-Reply-To: <e75b6cb0826c24f3c0583fb409473c494aff0f63.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<e75b6cb0826c24f3c0583fb409473c494aff0f63.1279104996.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 14 Jul 2010 20:30:23 +0800
Message-ID: <AANLkTimQnt8_OLGOp8VIUk6A10wBDNT3H_prpWNuYhc9@mail.gmail.com>
Subject: Re: [PATCH 2/3] usb/{gadget,host}: Remove dead CONFIG_CPU_PXA27x
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 7:32 PM, Christian Dietrich
<qy03fugy@stud.informatik.uni-erlangen.de> wrote:
> CONFIG_CPU_PXA27x doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  drivers/usb/gadget/pxa27x_udc.c |   16 ----------------
>  drivers/usb/host/ohci-pxa27x.c  |    8 --------
>  2 files changed, 0 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
> index 85b0d89..73783f5 100644
> --- a/drivers/usb/gadget/pxa27x_udc.c
> +++ b/drivers/usb/gadget/pxa27x_udc.c
> @@ -2561,12 +2561,6 @@ static void pxa_udc_shutdown(struct platform_device *_dev)
>                udc_disable(udc);
>  }
>
> -#ifdef CONFIG_CPU_PXA27x

This should be CONFIG_PXA27x, I'll prepare a patch on this.
