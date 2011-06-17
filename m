Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab1FQPMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:12:50 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60587 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab1FQPMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:12:47 -0400
Date: Fri, 17 Jun 2011 18:12:41 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] Drivers: gpu: drm: drm_memory: fixed coding style issue
Message-ID: <20110617151241.GH17833@sci.fi>
Mail-Followup-To: Chris Forbes <chrisf@ijw.co.nz>,
	David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1308296336-28871-1-git-send-email-chrisf@ijw.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1308296336-28871-1-git-send-email-chrisf@ijw.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 07:38:56PM +1200, Chris Forbes wrote:
> Fixed coding style issues flagged by checkpatch.pl.
> 
> Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
> ---
>  drivers/gpu/drm/drm_memory.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
> index c9b8050..516c86a 100644
> --- a/drivers/gpu/drm/drm_memory.c
> +++ b/drivers/gpu/drm/drm_memory.c
> @@ -57,7 +57,7 @@ int drm_mem_info(char *buf, char **start, off_t offset,
>  
>  #if __OS_HAS_AGP
>  static void *agp_remap(unsigned long offset, unsigned long size,
> -		       struct drm_device * dev)
> +		       struct drm_device *dev)
>  {
>  	unsigned long i, num_pages =
>  	    PAGE_ALIGN(size) / PAGE_SIZE;
> @@ -81,16 +81,18 @@ static void *agp_remap(unsigned long offset, unsigned long size,
>  		return NULL;
>  
>  	/*
> -	 * OK, we're mapping AGP space on a chipset/platform on which memory accesses by
> -	 * the CPU do not get remapped by the GART.  We fix this by using the kernel's
> -	 * page-table instead (that's probably faster anyhow...).
> +	 * OK, we're mapping AGP space on a chipset/platform on which
> +	 * memory accesses by the CPU do not get remapped by the GART.
> +	 * We fix this by using the kernel's page-table instead
> +	 * (that's probably faster anyhow...).
>  	 */
>  	/* note: use vmalloc() because num_pages could be large... */
>  	page_map = vmalloc(num_pages * sizeof(struct page *));
>  	if (!page_map)
>  		return NULL;
>  
> -	phys_page_map = (agpmem->memory->pages + (offset - agpmem->bound) / PAGE_SIZE);
> +	phys_page_map = (agpmem->memory->pages + (offset - agpmem->bound)
> +		/ PAGE_SIZE);

If you feel the need to do this, at least wrap it at '+', otherwise
you're making the order of operations harder to follow. And you might
as well remove the pointless parens while you're at it.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
