Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0HWVjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:39:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab0HWVjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:39:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] ACPI: Don't report current_now if battery reports in mWh
Date: Mon, 23 Aug 2010 23:37:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, cbou@mail.ru,
        dwmw2@infradead.org, lenb@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
References: <1282595132-5026-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1282595132-5026-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008232337.19715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 23, 2010, Matthew Garrett wrote:
> ACPI batteries can report in units of either current or energy. Right
> now we expose the current_now file even if the battery is reporting
> energy units, resulting in a file that should contain mA instead
> containing mW. Don't expose this value unless the battery is reporting
> current.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/battery.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index dc58402..9841720 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -273,7 +273,6 @@ static enum power_supply_property energy_battery_props[] = {
>  	POWER_SUPPLY_PROP_CYCLE_COUNT,
>  	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> -	POWER_SUPPLY_PROP_CURRENT_NOW,
>  	POWER_SUPPLY_PROP_POWER_NOW,
>  	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
>  	POWER_SUPPLY_PROP_ENERGY_FULL,
> 

