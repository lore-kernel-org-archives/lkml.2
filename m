Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938Ab0J0LZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:25:34 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:34559 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760927Ab0J0LZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:25:31 -0400
Message-ID: <4CC80BDC.2000803@ge.com>
Date: Wed, 27 Oct 2010 12:24:12 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 12/30] staging/vme/ca91cx42: declare static functions
 as such
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-13-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-13-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:25:29.0737 (UTC) FILETIME=[A92D0F90:01CB75C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   38 ++++++++++++++--------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 14e10a6..6dd895f 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -259,7 +259,7 @@ static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
>  /*
>   * Set up an VME interrupt
>   */
> -void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
> +static void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
>  	int sync)
>  
>  {
> @@ -287,7 +287,7 @@ void ca91cx42_irq_set(struct vme_bridge *ca91cx42_bridge, int level, int state,
>  	}
>  }
>  
> -int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
> +static int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
>  	int statid)
>  {
>  	u32 tmp;
> @@ -323,7 +323,7 @@ int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
>  	return 0;
>  }
>  
> -int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
> +static int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
>  	unsigned long long vme_base, unsigned long long size,
>  	dma_addr_t pci_base, vme_address_t aspace, vme_cycle_t cycle)
>  {
> @@ -429,7 +429,7 @@ int ca91cx42_slave_set(struct vme_slave_resource *image, int enabled,
>  	return 0;
>  }
>  
> -int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
> +static int ca91cx42_slave_get(struct vme_slave_resource *image, int *enabled,
>  	unsigned long long *vme_base, unsigned long long *size,
>  	dma_addr_t *pci_base, vme_address_t *aspace, vme_cycle_t *cycle)
>  {
> @@ -584,7 +584,7 @@ static void ca91cx42_free_resource(struct vme_master_resource *image)
>  }
>  
>  
> -int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
> +static int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
>  	unsigned long long vme_base, unsigned long long size,
>  	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
>  {
> @@ -741,7 +741,7 @@ err_window:
>  	return retval;
>  }
>  
> -int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
> +static int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
>  	unsigned long long *vme_base, unsigned long long *size,
>  	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
>  {
> @@ -828,7 +828,7 @@ int __ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
>  	return 0;
>  }
>  
> -int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
> +static int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
>  	unsigned long long *vme_base, unsigned long long *size,
>  	vme_address_t *aspace, vme_cycle_t *cycle, vme_width_t *dwidth)
>  {
> @@ -844,7 +844,7 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
>  	return retval;
>  }
>  
> -ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
> +static ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
>  	size_t count, loff_t offset)
>  {
>  	ssize_t retval;
> @@ -904,7 +904,7 @@ out:
>  	return retval;
>  }
>  
> -ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
> +static ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
>  	size_t count, loff_t offset)
>  {
>  	ssize_t retval;
> @@ -959,7 +959,7 @@ out:
>  	return retval;
>  }
>  
> -unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
> +static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
>  	unsigned int mask, unsigned int compare, unsigned int swap,
>  	loff_t offset)
>  {
> @@ -1015,7 +1015,7 @@ out:
>  	return result;
>  }
>  
> -int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
> +static int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
>  	struct vme_dma_attr *dest, size_t count)
>  {
>  	struct ca91cx42_dma_entry *entry, *prev;
> @@ -1176,7 +1176,7 @@ static int ca91cx42_dma_busy(struct vme_bridge *ca91cx42_bridge)
>  		return 1;
>  }
>  
> -int ca91cx42_dma_list_exec(struct vme_dma_list *list)
> +static int ca91cx42_dma_list_exec(struct vme_dma_list *list)
>  {
>  	struct vme_dma_resource *ctrlr;
>  	struct ca91cx42_dma_entry *entry;
> @@ -1258,7 +1258,7 @@ int ca91cx42_dma_list_exec(struct vme_dma_list *list)
>  
>  }
>  
> -int ca91cx42_dma_list_empty(struct vme_dma_list *list)
> +static int ca91cx42_dma_list_empty(struct vme_dma_list *list)
>  {
>  	struct list_head *pos, *temp;
>  	struct ca91cx42_dma_entry *entry;
> @@ -1280,7 +1280,7 @@ int ca91cx42_dma_list_empty(struct vme_dma_list *list)
>   * This does not enable the LM monitor - that should be done when the first
>   * callback is attached and disabled when the last callback is removed.
>   */
> -int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
> +static int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
>  	vme_address_t aspace, vme_cycle_t cycle)
>  {
>  	u32 temp_base, lm_ctl = 0;
> @@ -1348,7 +1348,7 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
>  /* Get configuration of the callback monitor and return whether it is enabled
>   * or disabled.
>   */
> -int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
> +static int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
>  	vme_address_t *aspace, vme_cycle_t *cycle)
>  {
>  	u32 lm_ctl, enabled = 0;
> @@ -1391,7 +1391,7 @@ int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
>   *
>   * Callback will be passed the monitor triggered.
>   */
> -int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
> +static int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
>  	void (*callback)(int))
>  {
>  	u32 lm_ctl, tmp;
> @@ -1440,7 +1440,7 @@ int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
>  /*
>   * Detach a callback function forn a specific location monitor.
>   */
> -int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
> +static int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
>  {
>  	u32 tmp;
>  	struct ca91cx42_driver *bridge;
> @@ -1473,7 +1473,7 @@ int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
>  	return 0;
>  }
>  
> -int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
> +static int ca91cx42_slot_get(struct vme_bridge *ca91cx42_bridge)
>  {
>  	u32 slot = 0;
>  	struct ca91cx42_driver *bridge;
> @@ -1833,7 +1833,7 @@ err_struct:
>  
>  }
>  
> -void ca91cx42_remove(struct pci_dev *pdev)
> +static void ca91cx42_remove(struct pci_dev *pdev)
>  {
>  	struct list_head *pos = NULL;
>  	struct vme_master_resource *master_image;


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
