Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1H2SPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:15:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41222 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416Ab1H2SPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:15:49 -0400
X-Sasl-enc: ZGxSYd8zxtLlwZD9nUtxbYmrsvuM/5HzDH6EzHV7JRUu 1314641749
Date: Mon, 29 Aug 2011 11:12:06 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 46/46] Staging: hv: Update the TODO file
Message-ID: <20110829181206.GB19668@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-46-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469905-7058-46-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:45AM -0700, K. Y. Srinivasan wrote:
> Update the TODO file.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/TODO |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
> index 582fd4a..23c74ed 100644
> --- a/drivers/staging/hv/TODO
> +++ b/drivers/staging/hv/TODO
> @@ -1,14 +1,30 @@
>  TODO:
> -	- fix remaining checkpatch warnings and errors
>  	- audit the vmbus to verify it is working properly with the
>  	  driver model
> -	- see if the vmbus can be merged with the other virtual busses
> -	  in the kernel
> +
> +		STATUS (July 19, 2011):
> +		All outstanding issues (known to us)  with regards
> +		to conforming to Linux Driver Model have been addressed.

The TODO file is not a place to have a "conversation" about what is and
is not completed by having status reports.

Let's discuss this through email, and if we all agree, then the TODO
entries can be removed.

greg k-h
