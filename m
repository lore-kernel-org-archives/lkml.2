Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1ETA6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:58:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35200 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab1ETA6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:58:12 -0400
X-Sasl-enc: gTA5imwwIH/io4eAqx36oy9ycxNxxxJ1RKb67AXG4e94 1305853091
Date: Thu, 19 May 2011 21:58:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manoj Iyer <manoj.iyer@canonical.com>,
        Andy Lutomirski <luto@mit.edu>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [08/71] thinkpad-acpi: module autoloading for newer Lenovo
 ThinkPads.
Message-ID: <20110520005808.GA10188@khazad-dum.debian.net>
References: <20110519180626.GA16555@kroah.com>
 <20110519180555.057280654@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519180555.057280654@clark.kroah.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.

No objections.  I am just replying to note that this patch is useful to all
current stable and longterm releases.

> ------------------
> 
> From: Manoj Iyer <manoj.iyer@canonical.com>
> 
> commit 9fbdaeb4f4dd14a0caa9fc35c496d5440c251a3a upstream.
> 
> The newer Lenovo ThinkPads have HKEY HID of LEN0068 instead
> of IBM0068. Added new HID so that thinkpad_acpi module will
> auto load on these newer Lenovo ThinkPads.
> 
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
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
>  
> 
> 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
