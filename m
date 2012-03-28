Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2C1RKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2C1RKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:10:45 -0400
Message-ID: <4F7338A6.3070008@redhat.com>
Date: Wed, 28 Mar 2012 13:13:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH] [trivial] edac: Fix document URLs
References: <1332944196-18524-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1332944196-18524-1-git-send-email-standby24x7@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-03-2012 11:16, Masanari Iida escreveu:
> URLs for Memory controller's datasheet are "page not found".
> Fix them to correct URLs.

I remember I validated a few of those links in the patchset that
is fixing the EDAC core.

I'll apply this one on my tree, of course for the hunks that don't
conflict with the ones I've already fixed.

Thanks,
Mauro.

> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> 
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/i5000_edac.c |    2 +-
>  drivers/edac/i5100_edac.c |    2 +-
>  drivers/edac/i5400_edac.c |    2 +-
>  drivers/edac/i7300_edac.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
> index a2680d8..9656802 100644
> --- a/drivers/edac/i5000_edac.c
> +++ b/drivers/edac/i5000_edac.c
> @@ -10,7 +10,7 @@
>   * This module is based on the following document:
>   *
>   * Intel 5000X Chipset Memory Controller Hub (MCH) - Datasheet
> - * 	http://developer.intel.com/design/chipsets/datashts/313070.htm
> + *     http://www.intel.com/content/dam/doc/datasheet/5000x-chipset-memory-controller-hub-datasheet.pdf
>   *
>   */
>  
> diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
> index 2e23547..13b0c2f 100644
> --- a/drivers/edac/i5100_edac.c
> +++ b/drivers/edac/i5100_edac.c
> @@ -7,7 +7,7 @@
>   * This module is based on the following document:
>   *
>   * Intel 5100X Chipset Memory Controller Hub (MCH) - Datasheet
> - *      http://download.intel.com/design/chipsets/datashts/318378.pdf
> + *      http://www.intel.com/content/dam/doc/datasheet/5100-memory-controller-hub-chipset-datasheet.pdf
>   *
>   * The intel 5100 has two independent channels. EDAC core currently
>   * can not reflect this configuration so instead the chip-select
> diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
> index 67ec962..41560c1 100644
> --- a/drivers/edac/i5400_edac.c
> +++ b/drivers/edac/i5400_edac.c
> @@ -16,7 +16,7 @@
>   * This module is based on the following document:
>   *
>   * Intel 5400 Chipset Memory Controller Hub (MCH) - Datasheet
> - * 	http://developer.intel.com/design/chipsets/datashts/313070.htm
> + *     http://www.intel.com/content/dam/doc/datasheet/5400-chipset-memory-controller-hub-datasheet.pdf
>   *
>   */
>  
> diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
> index 3bafa3b..48ffe3b 100644
> --- a/drivers/edac/i7300_edac.c
> +++ b/drivers/edac/i7300_edac.c
> @@ -10,7 +10,7 @@
>   * Red Hat Inc. http://www.redhat.com
>   *
>   * Intel 7300 Chipset Memory Controller Hub (MCH) - Datasheet
> - *	http://www.intel.com/Assets/PDF/datasheet/318082.pdf
> + *     http://www.intel.com/content/dam/doc/datasheet/7300-chipset-memory-controller-hub-datasheet.pdf
>   *
>   * TODO: The chipset allow checking for PCI Express errors also. Currently,
>   *	 the driver covers only memory error errors

