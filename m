Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0KHRj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:39:58 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32904 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab0KHRj5 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 8 Nov 2010 12:39:57 -0500
Date: Mon, 8 Nov 2010 12:39:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, bskeggs@redhat.com, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Bruce Edge <bruce.edge@gmail.com>, len.brown@intel.com
Subject: Re: [bruce.edge@gmail.com: PATCH: ERROR: "video_output_register"
 [drivers/acpi/video.ko] und]
Message-ID: <20101108173920.GA31176@dumpdata.com>
References: <20101108155110.GB8637@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108155110.GB8637@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:51:10AM -0500, Konrad Rzeszutek Wilk wrote:
> Hey guys,
> 
> This failure also occurs on v2.6.37-rc1 (the branch Bruce is
> referring has been merged in Linus's tree). This compile
> failure can be demonstrated if one does not 
> select VIDEO_OUTPUT_CONTROL and enables the Nouveau driver.
> 
> The i915 has a similar fix in the Kconfig 
> (ecb4aed78dcf09e48c8c34c8c2fa7f5c69344be6) but this one is lacking.
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Also Cc-ing LKML.
> 
> ----- Forwarded message from Bruce Edge <bruce.edge@gmail.com> -----
> 
> Date: Sun, 7 Nov 2010 17:56:38 -0800
> From: Bruce Edge <bruce.edge@gmail.com>
> To: xen-devel@lists.xensource.com,
> 	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Subject: PATCH: pvops 2.6.36 patch for undefined! ERROR: "video_output_register"
> 	[drivers/acpi/video.ko] und
> 
> This patch resolved the following link error:
> 
> ERROR: "video_output_unregister" [drivers/acpi/video.ko] undefined!
> ERROR: "video_output_register" [drivers/acpi/video.ko] undefined!
> 
> in this branch:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git-
> stable/xen-pcifront-0.8.2
> 
> --- old/drivers/gpu/drm/nouveau/Kconfig
> +++ new/drivers/gpu/drm/nouveau/Kconfig
> @@ -11,6 +11,7 @@
>         select FRAMEBUFFER_CONSOLE if !EMBEDDED
>         select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
>         select ACPI_VIDEO if ACPI
> +       select VIDEO_OUTPUT_CONTROL if ACPI
>         help
>           Choose this option for open-source nVidia support.
> 
> 
> -Bruce
> 
> ----- End forwarded message -----
