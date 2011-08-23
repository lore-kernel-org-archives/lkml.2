Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1HWXb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:31:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54580 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755930Ab1HWX2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:00 -0400
X-Sasl-enc: MI55/y1PWfufqZwpoTs0M8ZHQDI6FOn+RCL3+Ico+JDT 1314142079
Date: Tue, 23 Aug 2011 15:56:03 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 031/117] Staging: hv: netvsc: Get rid of the driver name
 initialization in netvsc.c
Message-ID: <20110823225603.GI9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-31-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-31-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:19AM -0700, K. Y. Srinivasan wrote:
> Now, get rid of the driver name initialization in  int netvsc_initialize().
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/netvsc.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
> index 6f4541b..d085018 100644
> --- a/drivers/staging/hv/netvsc.c
> +++ b/drivers/staging/hv/netvsc.c
> @@ -32,9 +32,6 @@
>  #include "hyperv_net.h"
>  
>  
> -/* Globals */
> -static const char *driver_name = "netvsc";
> -
>  static struct netvsc_device *alloc_net_device(struct hv_device *device)
>  {
>  	struct netvsc_device *net_device;
> @@ -999,7 +996,5 @@ cleanup:
>  int netvsc_initialize(struct hv_driver *drv)
>  {
>  
> -	drv->name = driver_name;
> -

Please merge this with the previous patch.

greg k-h
