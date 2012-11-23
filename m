Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2KWUax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:30:53 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab2KWUau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:30:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, mika.westerberg@linux.intel.com,
        linux-mmc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add SDHCI ACPI driver
Date: Fri, 23 Nov 2012 21:35:22 +0100
Message-ID: <3416042.oXdXWT2CDk@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
References: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 23, 2012 01:35:58 PM Adrian Hunter wrote:
> Hi
> 
> Here is SDHCI ACPI driver.
> 
> Changes for v2:
> 
> 	Dropped "PNPACPI: exclude SDHCI devices"
> 	Added "PNPACPI: exclude devices already bound"
> 	Changed dev->acpi_handle to ACPI_HANDLE(dev)
> 	Added Chris' Ack for sdhci-acpi
> 
> 
> Adrian Hunter (2):
>       ACPI: add SDHCI to ACPI platform devices
>       mmc: sdhci-acpi: add SDHCI ACPI driver
> 
> Mika Westerberg (1):
>       PNPACPI: exclude devices already bound

Applied to linux-pm.git/linux-next as v3.8 material.

Next time, however, I'll really prefer it if your changelogs (1) exist and (2)
are more descriptive than the (existing) ones in this series.

I added the changelogs for you (please check in the tree above if they make
sense), but that's not something I should be doing in general I think.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
