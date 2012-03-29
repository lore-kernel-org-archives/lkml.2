Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2C2IMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:12:40 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:45463 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2C2IMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:12:35 -0400
Message-ID: <4F74196C.2030206@ge.com>
Date: Thu, 29 Mar 2012 09:12:28 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging/vme: Fix module parameters in next-20120323
References: <1332498065-15573-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1332498065-15573-1-git-send-email-dev@snitselaar.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2012 08:12:30.0540 (UTC) FILETIME=[AFD410C0:01CD0D83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/12 10:21, Gerard Snitselaar wrote:
> loopback should be declared bool, and variant probably shouldn't be
> const.
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Looks good, thanks,

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_pio2_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
> index 9fedc44..573c800 100644
> --- a/drivers/staging/vme/devices/vme_pio2_core.c
> +++ b/drivers/staging/vme/devices/vme_pio2_core.c
> @@ -35,10 +35,10 @@ static int vector[PIO2_CARDS_MAX];
>  static int vector_num;
>  static int level[PIO2_CARDS_MAX];
>  static int level_num;
> -static const char *variant[PIO2_CARDS_MAX];
> +static char *variant[PIO2_CARDS_MAX];
>  static int variant_num;
>  
> -static int loopback;
> +static bool loopback;
>  
>  static int pio2_match(struct vme_dev *);
>  static int __devinit pio2_probe(struct vme_dev *);


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
