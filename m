Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1EYMPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:15:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:52821 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab1EYMPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:15:31 -0400
Date: Wed, 25 May 2011 14:15:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH trivial] hwrng: Fix spelling mistake in header
In-Reply-To: <1306325540-17934-1-git-send-email-levinsasha928@gmail.com>
Message-ID: <alpine.LNX.2.00.1105251415240.28291@pobox.suse.cz>
References: <1306325540-17934-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Sasha Levin wrote:

> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  include/linux/hw_random.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index 9bede76..b4b0eef 100644
> --- a/include/linux/hw_random.h
> +++ b/include/linux/hw_random.h
> @@ -25,7 +25,7 @@
>   *			there is always data available.  *OBSOLETE*
>   * @data_read:		Read data from the RNG device.
>   *			Returns the number of lower random bytes in "data".
> - *			Must not be NULL.    *OSOLETE*
> + *			Must not be NULL.    *OBSOLETE*
>   * @read:		New API. drivers can fill up to max bytes of data
>   *			into the buffer. The buffer is aligned for any type.
>   * @priv:		Private data, for use by the RNG driver.
> -- 
> 1.7.5.rc3

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
