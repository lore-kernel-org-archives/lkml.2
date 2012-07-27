Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2G0Daq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:30:46 -0400
Received: from cnc.isely.net ([75.149.91.89]:55770 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2G0Dap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:30:45 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 23:30:44 EDT
Date: Thu, 26 Jul 2012 22:25:11 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Tim Gardner <tim.gardner@canonical.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] pvrusb2: Declare MODULE_FIRMWARE usage
In-Reply-To: <1343329027-96369-1-git-send-email-tim.gardner@canonical.com>
Message-ID: <alpine.DEB.2.00.1207262224300.6058@ivanova.isely.net>
References: <1343329027-96369-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-By: Mike Isely <isely@pobox.com>

  -Mike


On Thu, 26 Jul 2012, Tim Gardner wrote:

> Cc: Mike Isely <isely@pobox.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/media/video/pvrusb2/pvrusb2-devattr.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> index d8c8982..adc501d3 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
> @@ -54,8 +54,9 @@ static const struct pvr2_device_client_desc pvr2_cli_29xxx[] = {
>  	{ .module_id = PVR2_CLIENT_ID_DEMOD },
>  };
>  
> +#define PVR2_FIRMWARE_29xxx "v4l-pvrusb2-29xxx-01.fw"
>  static const char *pvr2_fw1_names_29xxx[] = {
> -		"v4l-pvrusb2-29xxx-01.fw",
> +		PVR2_FIRMWARE_29xxx,
>  };
>  
>  static const struct pvr2_device_desc pvr2_device_29xxx = {
> @@ -87,8 +88,9 @@ static const struct pvr2_device_client_desc pvr2_cli_24xxx[] = {
>  	{ .module_id = PVR2_CLIENT_ID_DEMOD },
>  };
>  
> +#define PVR2_FIRMWARE_24xxx "v4l-pvrusb2-24xxx-01.fw"
>  static const char *pvr2_fw1_names_24xxx[] = {
> -		"v4l-pvrusb2-24xxx-01.fw",
> +		PVR2_FIRMWARE_24xxx,
>  };
>  
>  static const struct pvr2_device_desc pvr2_device_24xxx = {
> @@ -369,8 +371,9 @@ static const struct pvr2_device_client_desc pvr2_cli_73xxx[] = {
>  	  .i2c_address_list = "\x42"},
>  };
>  
> +#define PVR2_FIRMWARE_73xxx "v4l-pvrusb2-73xxx-01.fw"
>  static const char *pvr2_fw1_names_73xxx[] = {
> -		"v4l-pvrusb2-73xxx-01.fw",
> +		PVR2_FIRMWARE_73xxx,
>  };
>  
>  static const struct pvr2_device_desc pvr2_device_73xxx = {
> @@ -475,8 +478,9 @@ static const struct pvr2_dvb_props pvr2_751xx_dvb_props = {
>  };
>  #endif
>  
> +#define PVR2_FIRMWARE_75xxx "v4l-pvrusb2-73xxx-01.fw"
>  static const char *pvr2_fw1_names_75xxx[] = {
> -		"v4l-pvrusb2-73xxx-01.fw",
> +		PVR2_FIRMWARE_75xxx,
>  };
>  
>  static const struct pvr2_device_desc pvr2_device_750xx = {
> @@ -556,7 +560,10 @@ struct usb_device_id pvr2_device_table[] = {
>  };
>  
>  MODULE_DEVICE_TABLE(usb, pvr2_device_table);
> -
> +MODULE_FIRMWARE(PVR2_FIRMWARE_29xxx);
> +MODULE_FIRMWARE(PVR2_FIRMWARE_24xxx);
> +MODULE_FIRMWARE(PVR2_FIRMWARE_73xxx);
> +MODULE_FIRMWARE(PVR2_FIRMWARE_75xxx);
>  
>  /*
>    Stuff for Emacs to see, in order to encourage consistent editing style:
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
