Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0HXIoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:44:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:58781 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0HXInz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:43:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="599610273"
Subject: Re: [PATCH] ACPI: Don't report current_now if battery reports in
 mWh
From: Zhang Rui <rui.zhang@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <20100824081822.GA7963@oksana.dev.rtsoft.ru>
References: <1282595132-5026-1-git-send-email-mjg@redhat.com>
	 <201008232337.19715.rjw@sisk.pl>
	 <20100824081822.GA7963@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 16:47:06 +0800
Message-ID: <1282639626.3707.10.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 16:18 +0800, Anton Vorontsov wrote:
> On Mon, Aug 23, 2010 at 11:37:19PM +0200, Rafael J. Wysocki wrote:
> > On Monday, August 23, 2010, Matthew Garrett wrote:
> > > ACPI batteries can report in units of either current or energy. Right
> > > now we expose the current_now file even if the battery is reporting
> > > energy units, resulting in a file that should contain mA instead
> > > containing mW. Don't expose this value unless the battery is reporting
> > > current.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > 
> > Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Looks good to me as well.
> 
> Should I merge this into the battery-2.6.git tree, or
> ACPI folks are gonna handle this patch?
> 
Acked-by: Zhang Rui <rui.zhang@intel.com>

I think Len may want to handle this patch. :)

thanks,
rui

> Thanks,
> 
> > > ---
> > >  drivers/acpi/battery.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> > > index dc58402..9841720 100644
> > > --- a/drivers/acpi/battery.c
> > > +++ b/drivers/acpi/battery.c
> > > @@ -273,7 +273,6 @@ static enum power_supply_property energy_battery_props[] = {
> > >  	POWER_SUPPLY_PROP_CYCLE_COUNT,
> > >  	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> > >  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> > > -	POWER_SUPPLY_PROP_CURRENT_NOW,
> > >  	POWER_SUPPLY_PROP_POWER_NOW,
> > >  	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
> > >  	POWER_SUPPLY_PROP_ENERGY_FULL,
> > > 
> 


