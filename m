Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2EKLEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:04:44 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:36553 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EKLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:04:43 -0400
Message-ID: <4FACF248.8020602@ge.com>
Date: Fri, 11 May 2012 12:04:40 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] Staging: ipack/bridges/tpci200: change the licence
 to explicitly GPLv2
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com> <1336724236-21665-5-git-send-email-siglesias@igalia.com>
In-Reply-To: <1336724236-21665-5-git-send-email-siglesias@igalia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/12 09:17, Samuel Iglesias Gonsalvez wrote:
> Change the licence to explicitly GPLv2 to avoid possible conflicts in the
> future.
> 

This could probably be rolled up into patch 4.

Martyn

> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |    3 +--
>  drivers/staging/ipack/bridges/tpci200.h |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
> index 08cd851..80cdd9e 100644
> --- a/drivers/staging/ipack/bridges/tpci200.c
> +++ b/drivers/staging/ipack/bridges/tpci200.c
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
> diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
> index e452da2..75801f6 100644
> --- a/drivers/staging/ipack/bridges/tpci200.h
> +++ b/drivers/staging/ipack/bridges/tpci200.h
> @@ -8,8 +8,7 @@
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the Free
> - * Software Foundation; either version 2 of the License, or (at your option)
> - * any later version.
> + * Software Foundation; version 2 of the License.
>   */
>  
>  #ifndef _TPCI200_H_


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
