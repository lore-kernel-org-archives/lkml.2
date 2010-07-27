Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0G0OyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:54:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40704 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0G0OyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=duIDFro9x0hB/aiyIFG2fd28N8jwm+elUS9xGI4PFGpUcrt4wWteLU9+aQga527K4Y
         ZQDW9M34HTeskD7tJEFB06SJ6pnTOvOFiG97UyC2epFzTdAQ4HEHoLVNpOcnwba0WiR/
         GS3Ne9bzE7YRUHYHAJAmZgq8V3pXZIKtHl7Qw=
Date: Tue, 27 Jul 2010 20:22:47 +0530
From: Rabin Vincent <rabin@rab.in>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, a.zummo@towertech.it, gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Subject: Re: [PATCH 3/3] rtc: Add MAX8998 rtc driver
Message-ID: <20100727145247.GA23448@debian>
References: <1279609058-32319-1-git-send-email-jy0922.shim@samsung.com>
 <1279609058-32319-3-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279609058-32319-3-git-send-email-jy0922.shim@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 03:57:38PM +0900, Joonyoung Shim wrote:
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index 7e4489f..0612851 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -30,9 +30,12 @@
>  #include <linux/mfd/max8998.h>
>  #include <linux/mfd/max8998-private.h>
>  
> +#define RTC_I2C_ADDR		(0x0c >> 1)
> +
>  static struct mfd_cell max8998_devs[] = {
>  	{
>  		.name = "max8998-pmic",
> +		.name = "max8998-rtc",
>  	}
>  };

Missing braces?
