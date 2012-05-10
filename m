Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab2EJMpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:45:24 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:58492 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab2EJMpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:45:22 -0400
Message-ID: <1336653906.2494.129.camel@ted>
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for LED subsystem
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org
Date: Thu, 10 May 2012 13:45:06 +0100
In-Reply-To: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
References: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 08:26 +0800, Bryan Wu wrote:
> Add Bryan Wu as the primary maintainer for drivers/leds
> 
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>

> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7071633..de4e280 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4034,6 +4034,7 @@ F:	Documentation/scsi/53c700.txt
>  F:	drivers/scsi/53c700*
>  
>  LED SUBSYSTEM
> +M:	Bryan Wu <bryan.wu@canonical.com>
>  M:	Richard Purdie <rpurdie@rpsys.net>
>  S:	Maintained
>  F:	drivers/leds/


