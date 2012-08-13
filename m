Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2HMUuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:50:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HMUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:49:59 -0400
Date: Mon, 13 Aug 2012 15:49:46 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 1/2] gmux: Add generic write32 function
Message-ID: <20120813204946.GH24088@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <1344889232-3907-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344889232-3907-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:20:31PM -0400, Matthew Garrett wrote:
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
> index a0a3fe3..818b93c 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bios.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
> @@ -6473,6 +6473,9 @@ nouveau_run_vbios_init(struct drm_device *dev)
>  		}
>  	}
>  
> +	if (!bios->execute)
> +		nouveau_gpio_reset(dev);
> +
>  	return ret;
>  }

This part doesn't seem to belong.

