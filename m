Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab2JYQTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:19:10 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62344 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2JYQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1351170541-22570-1-git-send-email-e-mail@date.by>
References: <1351170541-22570-1-git-send-email-e-mail@date.by>
Date: Thu, 25 Oct 2012 12:19:06 -0400
Message-ID: <CADnq5_OkrjF=o2H7HtZzvLkitO64aH31ZdYnmdXVD6hL9S3XcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/radeon: fix ATPX function documentation
From: Alex Deucher <alexdeucher@gmail.com>
To: Igor Murzov <e-mail@date.by>
Cc: Alex Deucher <alexander.deucher@amd.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 9:09 AM, Igor Murzov <e-mail@date.by> wrote:
> Fix a copy&pasted documentation.
>
> Signed-off-by: Igor Murzov <e-mail@date.by>

Thanks.  I've added this to my queue.

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_atpx_handler.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
> index 37f6a90..15f5ded 100644
> --- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
> +++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
> @@ -352,9 +352,9 @@ static int radeon_atpx_switchto(enum vga_switcheroo_client_id id)
>  }
>
>  /**
> - * radeon_atpx_switchto - switch to the requested GPU
> + * radeon_atpx_power_state - power down/up the requested GPU
>   *
> - * @id: GPU to switch to
> + * @id: GPU to power down/up
>   * @state: requested power state (0 = off, 1 = on)
>   *
>   * Execute the necessary ATPX function to power down/up the discrete GPU
> --
> 1.7.12.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
