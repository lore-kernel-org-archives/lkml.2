Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab2EKLFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:05:15 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:53267 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EKLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:05:13 -0400
Message-ID: <4FACF265.7010205@ge.com>
Date: Fri, 11 May 2012 12:05:09 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Staging: ipack/devices/ipoctal: change the licence
 to explicitly GPLv2
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com> <1336724236-21665-6-git-send-email-siglesias@igalia.com>
In-Reply-To: <1336724236-21665-6-git-send-email-siglesias@igalia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/12 09:17, Samuel Iglesias Gonsalvez wrote:
> Change the licence to explicitly GPLv2 to avoid possible conflicts in the
> future.
> 

This could also probably be rolled up into patch 4.

Martyn

> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/devices/ipoctal.c |    3 +--
>  drivers/staging/ipack/devices/ipoctal.h |    3 +--
>  drivers/staging/ipack/devices/scc2698.h |    3 +--
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
> index 15c0c6b..a28c677 100644
> --- a/drivers/staging/ipack/devices/ipoctal.c
> +++ b/drivers/staging/ipack/devices/ipoctal.c
> @@ -8,8 +8,7 @@
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> - * any later version.
> + * Software Foundation; version 2 of the License.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
> index 7c5d211..266f361 100644
> --- a/drivers/staging/ipack/devices/ipoctal.h
> +++ b/drivers/staging/ipack/devices/ipoctal.h
> @@ -8,8 +8,7 @@
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> - * any later version.
> + * Software Foundation; version 2 of the License.
>   */
>  
>  #ifndef _IPOCTAL_H
> diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
> index e683019..47f6269 100644
> --- a/drivers/staging/ipack/devices/scc2698.h
> +++ b/drivers/staging/ipack/devices/scc2698.h
> @@ -8,8 +8,7 @@
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> - * any later version.
> + * Software Foundation; version 2 of the License.
>   */
>  
>  #ifndef SCC2698_H_


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
