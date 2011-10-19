Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1JSWGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:06:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1JSWGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:06:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: ACPI: Add Sony VGN-FW21E to nonvs blacklist.
Date: Thu, 20 Oct 2011 00:08:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
References: <20111019170642.GD2116@redhat.com>
In-Reply-To: <20111019170642.GD2116@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110200008.41478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 19, 2011, Dave Jones wrote:
> As noted by a user in https://bugzilla.redhat.com/show_bug.cgi?id=641789
> The Sony VGN-FW21E also needs the nonvs by default workaround added.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 3ed80b2..17fc718 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -390,6 +390,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
>  	},
>  	{
>  	.callback = init_nvs_nosave,
> +	.ident = "Sony Vaio VGN-FW21E",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
> +		},
> +	},
> +	{
> +	.callback = init_nvs_nosave,
>  	.ident = "Sony Vaio VGN-SR11M",
>  	.matches = {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

