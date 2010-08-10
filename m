Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0HJPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:32:06 -0400
Received: from compulab.co.il ([67.18.134.219]:37004 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0HJPb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:31:57 -0400
Message-ID: <4C6170D5.3010904@compulab.co.il>
Date: Tue, 10 Aug 2010 18:31:33 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Remove default DEBUG define from TPS6586x
References: <1281452533-9341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1281452533-9341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/regulator/tps6586x-regulator.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
> index 3c2eee8..fd14c59 100644
> --- a/drivers/regulator/tps6586x-regulator.c
> +++ b/drivers/regulator/tps6586x-regulator.c
> @@ -13,7 +13,6 @@
>   * published by the Free Software Foundation.
>   */
>  
> -#define DEBUG
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/err.h>


-- 
Sincerely yours,
Mike.
