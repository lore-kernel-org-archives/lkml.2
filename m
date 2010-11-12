Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0KLBL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:11:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:13487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab0KLBL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:11:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,185,1288594800"; 
   d="scan'208";a="572740203"
Subject: Re: [PATCH] acpi: Provide decls for standalone compilation of
 video.h without ACPI (v2)
From: Zhang Rui <rui.zhang@intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, "Brown, Len" <len.brown@intel.com>
In-Reply-To: <1283694709-8504-1-git-send-email-chris@chris-wilson.co.uk>
References: <1283693757-8199-1-git-send-email-chris@chris-wilson.co.uk>
	 <1283694709-8504-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 09:12:37 +0800
Message-ID: <1289524357.8148.1396.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 21:51 +0800, Chris Wilson wrote:
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Len Brown <len.brown@intel.com>

Acked-by: Zhang Rui <rui.zhang@intel.com>

> ---
>  include/acpi/video.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/acpi/video.h b/include/acpi/video.h
> index 551793c..0e98e67 100644
> --- a/include/acpi/video.h
> +++ b/include/acpi/video.h
> @@ -1,6 +1,10 @@
>  #ifndef __ACPI_VIDEO_H
>  #define __ACPI_VIDEO_H
>  
> +#include <linux/errno.h> /* for ENODEV */
> +
> +struct acpi_device;
> +
>  #define ACPI_VIDEO_DISPLAY_CRT  1
>  #define ACPI_VIDEO_DISPLAY_TV   2
>  #define ACPI_VIDEO_DISPLAY_DVI  3
> @@ -26,4 +30,3 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
>  #endif
>  
>  #endif
> -


