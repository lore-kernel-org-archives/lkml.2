Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1IVQ36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:29:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49788 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab1IVQ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:29:57 -0400
X-Sasl-enc: mNNRphUxGP2UtbUFOdOQzKm+DqEeUrQgpOFvh1wlHRp0 1316708996
Date: Thu, 22 Sep 2011 09:29:53 -0700
From: Greg KH <greg@kroah.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, tomas.winkler@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922162953.GA31282@kroah.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 04:45:31PM +0300, Oren Weil wrote:
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> ---
>  drivers/staging/mei/TODO |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO
> index 3b6a667..7d9a13b 100644
> --- a/drivers/staging/mei/TODO
> +++ b/drivers/staging/mei/TODO
> @@ -1,14 +1,4 @@
>  TODO:
> -	- Create in-kernel Client API. Examples of in-kernel clients are watchdog and AMTHI.

Did you really do this?

> -	- ME Watchdog Driver to expose standard Linux watchdog interface

And this?

> -	- Rewrite AMTHI to use in-kernel client interface

And this?

> -	- Cleanup init and probe functions
> -	- Review BUG/BUG_ON usage
> -	- Cleanup and reorganize header files
> -	- Rewrite client data structure

And this?

> -	- Make state machine more readable
> -	- Add mei.txt with driver explanation and it's driver

You really don't describe the kernel/user api here, that needs to be
well documented as it is a ABI you are creating and we need to know how
it works.

thanks,

greg k-h
