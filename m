Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0GWGpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 02:45:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57501 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0GWGpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iFouLzUmrB3TDvTV4krRNDvcjzbp+3rLEU43RvRUbOKVvdZcz2jATlBvr3amysRmMU
         7/VNrLHyf7jSDXtId+TaFpuenxHRzZVcab39Vux1MXPCZOgHN0H9G31Kqa39kqtprp4Y
         Rf2yYx5ywmPINjHOaSzlDhQCctwfnSV3N5Ogg=
Date: Thu, 22 Jul 2010 23:45:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Matthew Garrett <mjg@redhat.com>,
        Elliott Sales de Andrade <quantum.analyst@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org
Subject: Re: [PATCH] i8042: add Gigabyte Spring Peak to dmi_noloop_table
Message-ID: <20100723064534.GD20532@core.coreip.homeip.net>
References: <1279561534-3551-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279561534-3551-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:45:34AM -0700, Kamal Mostafa wrote:
> Gigabyte "Spring Peak" notebook indicates wrong chassis-type, tripping up
> i8042 and breaking the touchpad.  Add this model to i8042_dmi_noloop_table[]
> to resolve.
> 
> BugLink: https://bugs.launchpad.net/bugs/580664
> 
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> Cc: <stable@kernel.org>

Applied, thanks Kamal.

> ---
>  drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index 6168469..d953d65 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -166,6 +166,13 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
>  		},
>  	},
>  	{
> +		/* Gigabyte Spring Peak */
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
> +		},
> +	},
> +	{
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
> -- 
> 1.7.0.4
> 

-- 
Dmitry
