Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0FGSw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:52:57 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:37611 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab0FGSwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:52:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C0D3FFB.7040704@cam.ac.uk>
Date: Mon, 07 Jun 2010 19:52:43 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 09/17] MAINTAINERS: Add STAGING - INDUSTRIAL IO
References: <cover.1275935090.git.joe@perches.com> <81391f52a009e825f5a3bfd73a71ba24190d6f3b.1275935091.git.joe@perches.com>
In-Reply-To: <81391f52a009e825f5a3bfd73a71ba24190d6f3b.1275935091.git.joe@perches.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/10 19:49, Joe Perches wrote:

Good idea.  Could we have the mailing list as well.
L: linux-iio@vger.kernel.org

I can do it as an incremental patch if you would prefer.
Either way,

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 71e6fe3..680d602 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5497,6 +5497,11 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
>  S:	Odd Fixes
>  F:	drivers/staging/hv/
>  
> +STAGING - INDUSTRIAL IO
> +M:	Jonathan Cameron <jic23@cam.ac.uk>
> +S:	Odd Fixes
> +F:	drivers/staging/iio/
> +
>  STARFIRE/DURALAN NETWORK DRIVER
>  M:	Ion Badulescu <ionut@badula.org>
>  S:	Odd Fixes

