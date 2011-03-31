Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab1CaRoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:44:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42829 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab1CaRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GcVVO3A6ZxhDA1cd9Mm1Ag3n4VALo9GP9zlxm+LI2SpUplIsTFgq2W5JbcaqOKOOkh
         HNw/dweJtoDLlZNEjmWX6mjU9rm+7xHj0w204PbxJ8t9ek72nOuhPBdsyLPJMCiGsqtJ
         4IDzuTL+PrWNBPDWrpU1bfgsb0uEsMK2HkG1w=
Date: Thu, 31 Mar 2011 10:43:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, pingc@wacom.com, chris@cnpbagwell.com
Subject: Re: [PATCH] add support for Lenovo tablet ID (0xE6)
Message-ID: <20110331174334.GA414@core.coreip.homeip.net>
References: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>
 <1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:20:52PM -0500, Manoj Iyer wrote:
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/input/tablet/wacom_wac.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
> index 5597637..f751224 100644
> --- a/drivers/input/tablet/wacom_wac.c
> +++ b/drivers/input/tablet/wacom_wac.c
> @@ -1364,6 +1364,8 @@ static const struct wacom_features wacom_features_0xE2 =
>  	{ "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
>  static const struct wacom_features wacom_features_0xE3 =
>  	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
> +static const struct wacom_features wacom_features_0xE6 =
> +	{ "ISD-V4",       	  WACOM_PKGLEN_TPC2FG,    27760, 15694,  255,  0, TABLETPC2FG };

Manoj, shouldn't we call it "Wacom ISDv4 E6" to be consistent?

Ping, is resolution the same as with other "ISDv4"s?

Thanks,

-- 
Dmitry
