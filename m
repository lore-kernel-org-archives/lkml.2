Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2HNJOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:14:06 -0400
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:37208 "EHLO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab2HNJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:14:04 -0400
Message-ID: <502A16D8.5040206@ge.com>
Date: Tue, 14 Aug 2012 10:14:00 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2]staging "vme" Fix typos.
References: <1344878902-22059-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1344878902-22059-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/12 18:28, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
> Note:resend with minor adjustments.
> The below patch fixes typos found while reading through staging "vme"
> 
>  drivers/staging/vme/devices/vme_user.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index e25645e..0170788 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -64,13 +64,13 @@ static unsigned int bus_num;
>   *
>   * However the VME driver at http://www.vmelinux.org/ is rather old and doesn't
>   * even support the tsi148 chipset (which has 8 master and 8 slave windows).
> - * We'll run with this or now as far as possible, however it probably makes
> + * We'll run with this for now as far as possible, however it probably makes
>   * sense to get rid of the old mappings and just do everything dynamically.
>   *
>   * So for now, we'll restrict the driver to providing 4 masters and 4 slaves as
>   * defined above and try to support at least some of the interface from
> - * http://www.vmelinux.org/ as an alternative drive can be written providing a
> - * saner interface later.
> + * http://www.vmelinux.org/ as an alternative the driver can be written
> + * providing a saner interface later.
>   *
>   * The vmelinux.org driver never supported slave images, the devices reserved
>   * for slaves were repurposed to support all 8 master images on the UniverseII!
> @@ -242,7 +242,7 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
>  }
>  
>  /*
> - * We are going ot alloc a page during init per window for small transfers.
> + * We are going to alloc a page during init per window for small transfers.
>   * Small transfers will go user space -> buffer -> VME. Larger (more than a
>   * page) transfers will lock the user space buffer into memory and then
>   * transfer the data directly from the user space buffers out to VME.
> 

Thanks for updating the patch, that's much better:

Acked-by: Martyn Welch <martyn.welch@ge.com>

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
