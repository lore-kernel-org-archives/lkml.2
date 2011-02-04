Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1BDVBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:01:49 -0500
Received: from kroah.org ([198.145.64.141]:50619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1BDVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:01:40 -0500
Date: Fri, 4 Feb 2011 12:59:19 -0800
From: Greg KH <greg@kroah.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, henryp@broadcom.com, gregkh@suse.de,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8]staging: brcm80211i: sbsdio.h: change a typo
 comamnd to command
Message-ID: <20110204205919.GA15658@kroah.com>
References: <1296623248-5399-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296623248-5399-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 09:07:28PM -0800, Justin P. Mattock wrote:
> The below patch fixes a typo comamnd to command.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/staging/brcm80211/include/sbsdio.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/include/sbsdio.h b/drivers/staging/brcm80211/include/sbsdio.h
> index 6afdbbe..c190acb 100644
> --- a/drivers/staging/brcm80211/include/sbsdio.h
> +++ b/drivers/staging/brcm80211/include/sbsdio.h
> @@ -144,7 +144,7 @@
>  						 */
>  
>  #define SBSDIO_BYTEMODE_DATALEN_MAX	64	/* sdio byte mode: maximum length of one
> -						 * data comamnd
> +						 * data command 

This patch adds a trailing space, which is not allowed.

Please fix this and resend.

thanks,

greg k-h
