Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0ITJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:51:46 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:45455 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0ITJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:51:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C972FE5.2070103@cam.ac.uk>
Date: Mon, 20 Sep 2010 10:56:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 2/6] MAINTAINERS: Merge imote2 and stargate
References: <cover.1284937055.git.joe@perches.com> <33b49e667f4b875a383dd5ba1db168b6ce8225ec.1284937055.git.joe@perches.com>
In-Reply-To: <33b49e667f4b875a383dd5ba1db168b6ce8225ec.1284937055.git.joe@perches.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/10 00:10, Joe Perches wrote:
> Removed by commit dcd925f95194da42e42cea7e5f901f9746cf441c
> 
> CC: Jonathan Cameron <jic23@cam.ac.uk>
> CC: Eric Miao <eric.y.miao@gmail.com>
Doh!  Good point, I forgot about the MAINTAINERS file when I did that
merge. Thanks Joe,

> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  MAINTAINERS |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a9f0567..03929b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -755,13 +755,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-ixp4xx/
>  
> -ARM/INTEL RESEARCH IMOTE 2 MACHINE SUPPORT
> -M:	Jonathan Cameron <jic23@cam.ac.uk>
> -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -S:	Maintained
> -F:	arch/arm/mach-pxa/imote2.c
> -
> -ARM/INTEL RESEARCH STARGATE 2 MACHINE SUPPORT
> +ARM/INTEL RESEARCH IMOTE/STARGATE 2 MACHINE SUPPORT
>  M:	Jonathan Cameron <jic23@cam.ac.uk>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained



