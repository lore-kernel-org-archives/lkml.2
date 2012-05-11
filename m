Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab2EKLET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:04:19 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:38853 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab2EKLER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:04:17 -0400
Message-ID: <4FACF22C.1050304@ge.com>
Date: Fri, 11 May 2012 12:04:12 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Staging: ipack: move the devices source line in Kconfig
 file
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com> <1336724236-21665-2-git-send-email-siglesias@igalia.com>
In-Reply-To: <1336724236-21665-2-git-send-email-siglesias@igalia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/12 09:17, Samuel Iglesias Gonsalvez wrote:
> Maintain the proper order of definitions in Kconfig following the time order of
> the commits.
> 

This could probably be rolled up into patch 1.

Martyn

> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
> index 619c149..4f4b9d6 100644
> --- a/drivers/staging/ipack/Kconfig
> +++ b/drivers/staging/ipack/Kconfig
> @@ -9,8 +9,8 @@ menuconfig IPACK_BUS
>  
>  if IPACK_BUS
>  
> -source "drivers/staging/ipack/devices/Kconfig"
> -
>  source "drivers/staging/ipack/bridges/Kconfig"
>  
> +source "drivers/staging/ipack/devices/Kconfig"
> +
>  endif # IPACK


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
