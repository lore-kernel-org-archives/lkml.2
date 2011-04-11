Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DKGgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:36:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1DKGgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:36:52 -0400
Date: Sun, 10 Apr 2011 23:36:48 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fsldma: fix build warning caused by of_platform_device
 changes
Message-ID: <20110411063648.GB4439@angua.secretlab.ca>
References: <1302197583-31771-1-git-send-email-iws@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302197583-31771-1-git-send-email-iws@ovro.caltech.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 10:33:03AM -0700, Ira W. Snyder wrote:
> Commit 000061245a6797d542854106463b6b20fbdcb12e forgot to convert the
> type of structure passed into platform_device_register() when it was
> converted from of_platform_device_register. Fix it.
> 
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Dan Williams <dan.j.williams@intel.com>

Applied thanks.

One comment however; when quoting sha1 commit id's, please also quote
the title of the patch.  Very few people I know can remember off the
top of their head the commit names that goes with a sha1 id.  :-)

g.

> ---
>  drivers/dma/fsldma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 6b39675..8a78154 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1448,7 +1448,7 @@ static const struct of_device_id fsldma_of_ids[] = {
>  	{}
>  };
>  
> -static struct of_platform_driver fsldma_of_driver = {
> +static struct platform_driver fsldma_of_driver = {
>  	.driver = {
>  		.name = "fsl-elo-dma",
>  		.owner = THIS_MODULE,
> -- 
> 1.7.3.4
> 
