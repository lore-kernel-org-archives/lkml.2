Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1CHMlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:41:45 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46193 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab1CHMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:41:44 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 07:41:44 EST
X-Sasl-enc: 9UXKl9UDVvondCoZxr07vyUbmWlWe3y7KKXOOsgpTG1+ 1299587744
Date: Tue, 8 Mar 2011 09:35:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo
 ThinkPads.
Message-ID: <20110308123541.GA11804@khazad-dum.debian.net>
References: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
 <1299540407-3779-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299540407-3779-2-git-send-email-manoj.iyer@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011, Manoj Iyer wrote:
> The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
> of IBM0068. Added new HID so that thinkpad_acpi module will
> auto load on these newer Lenovo ThinkPads.
> 
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index eb99223..125d891 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -128,7 +128,8 @@ enum {
>  };
>  
>  /* ACPI HIDs */
> -#define TPACPI_ACPI_HKEY_HID		"IBM0068"
> +#define TPACPI_ACPI_IBM_HKEY_HID	"IBM0068"
> +#define TPACPI_ACPI_LENOVO_HKEY_HID	"LEN0068"
>  #define TPACPI_ACPI_EC_HID		"PNP0C09"
>  
>  /* Input IDs */
> @@ -3879,7 +3880,8 @@ errexit:
>  }
>  
>  static const struct acpi_device_id ibm_htk_device_ids[] = {
> -	{TPACPI_ACPI_HKEY_HID, 0},
> +	{TPACPI_ACPI_IBM_HKEY_HID, 0},
> +	{TPACPI_ACPI_LENOVO_HKEY_HID, 0},
>  	{"", 0},
>  };

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
