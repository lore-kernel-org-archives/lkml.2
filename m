Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2KXPE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 10:04:26 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:5168 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2KXPEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 10:04:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEFAMfgsFBbdWOb/2dsb2JhbABEhWG6XBZzgh4BAQUyAUUBEAsYCRYPCQMCAQIBRQYNAQUCAogNvjKMNwmEOAOWAZBEgnCBXg
Message-ID: <50B0E1FB.7000105@igalia.com>
Date: Sat, 24 Nov 2012 16:04:27 +0100
From: =?ISO-8859-1?Q?Javier_Mu=F1oz?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: linux-kernel@vger.kernel.org, Teddy Wang <teddy.wang@siliconmotion.com.cn>
Subject: Re: [PATCH 23/24] MAINTAINERS: fix drivers/staging/sm7xx/
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net> <1353716808-16375-24-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1353716808-16375-24-git-send-email-cesarb@cesarb.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Javier Muñoz <jmunhoz@igalia.com>

Thanks Cesar!

Javier

On 11/24/2012 01:26 AM, Cesar Eduardo Barros wrote:
> This directory was moved to drivers/staging/sm7xxfb/ by commit 925aa66
> (staging: sm7xxfb: sm7xx becomes sm7xxfb).
> 
> Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
> Cc: Javier M. Mellid <jmunhoz@igalia.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 328ba4f..e8990d2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7073,7 +7073,7 @@ F:	drivers/staging/rtl8712/
>  STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
>  M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
>  S:	Odd Fixes
> -F:	drivers/staging/sm7xx/
> +F:	drivers/staging/sm7xxfb/
>  
>  STAGING - SOFTLOGIC 6x10 MPEG CODEC
>  M:	Ben Collins <bcollins@bluecherry.net>

