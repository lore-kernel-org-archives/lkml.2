Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1KCASY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:18:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1KCASV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:18:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: ACPI / PM: Add Sony VPCEB17FX to nonvs blacklist
Date: Thu, 3 Nov 2011 01:20:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111101164851.GA9444@redhat.com>
In-Reply-To: <20111101164851.GA9444@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030120.56143.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 01, 2011, Dave Jones wrote:
> Another entry for the nonvs blacklist, as noted by a user in
> https://bugzilla.redhat.com/show_bug.cgi?id=641789#c12
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index 0e46fae..6d9a3ab 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -398,6 +398,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
>  	},
>  	{
>  	.callback = init_nvs_nosave,
> +	.ident = "Sony Vaio VPCEB17FX",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB17FX"),
> +		},
> +	},
> +	{
> +	.callback = init_nvs_nosave,
>  	.ident = "Sony Vaio VGN-SR11M",
>  	.matches = {
>  		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> 
> 

