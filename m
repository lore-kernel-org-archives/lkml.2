Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2ETKI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:08:58 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50970 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2ETKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:08:56 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 06:08:56 EDT
Date: Sun, 20 May 2012 12:01:38 +0200
From: Andreas Mohr <andi@lisas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/2] ACPI / PM: Fix error messages in drivers/acpi/bus.c
Message-ID: <20120520100138.GA20179@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205182300.23142.rjw@sisk.pl>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> --- linux.orig/drivers/acpi/bus.c
> +++ linux/drivers/acpi/bus.c
> @@ -182,6 +182,24 @@ EXPORT_SYMBOL(acpi_bus_get_private_data)
>                                   Power Management
>     -------------------------------------------------------------------------- */
>  
> +static char *state_string(int state)
> +{
> +	switch (state) {
> +	case ACPI_STATE_D0:
> +		return "D0";
> +	case ACPI_STATE_D1:
> +		return "D1";

"const char", please?

In general: nice work, thanks!

Andreas Mohr
