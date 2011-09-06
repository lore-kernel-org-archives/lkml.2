Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1IGAA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 20:00:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39482 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755334Ab1IGAAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 20:00:52 -0400
X-Sasl-enc: 3KRMK6CYShwnGJXAh4c7ZSlH7uRyvpG8X5jlUf60PKaw 1315353651
Date: Tue, 6 Sep 2011 16:57:55 -0700
From: Greg KH <greg@kroah.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] one typo fix
Message-ID: <20110906235755.GA10586@kroah.com>
References: <1315166085-27984-1-git-send-email-asido4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315166085-27984-1-git-send-email-asido4@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 09:54:43PM +0200, Arvydas Sidorenko wrote:
> Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
> ---
>  drivers/staging/crystalhd/bc_dts_defs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
> index 778e76a..8c6ac3e 100644
> --- a/drivers/staging/crystalhd/bc_dts_defs.h
> +++ b/drivers/staging/crystalhd/bc_dts_defs.h
> @@ -84,7 +84,7 @@ enum BC_SW_OPTIONS {
>  	BC_OPT_LINK_OUT_ENCRYPT		= BC_BIT(29),
>  };
>  
> -struct BC_REG_CONFIG{
> +struct BC_REG_CONFIG {

That's not a "typo", it's a style fix, right?

Also, please give a good Subject: line for your emails.  This one would
be:
	Subject: staging: crystalhd: bc_dts_defs.h: fix a coding style issue

Care to redo all 3 patches in this series in this way, properly
describing what you are doing, so I can apply them?

thanks,

greg k-h
