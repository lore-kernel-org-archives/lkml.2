Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2KWKqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:46:52 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:34694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab2KWKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:46:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add SDHCI ACPI driver
Date: Fri, 23 Nov 2012 11:51:17 +0100
Message-ID: <3127178.CqJ7eQFZtV@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50AF4E8F.1030406@intel.com>
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com> <3578053.jWYihc5IJI@vostro.rjw.lan> <50AF4E8F.1030406@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 23, 2012 12:23:11 PM Adrian Hunter wrote:
> On 22/11/12 23:24, Rafael J. Wysocki wrote:
> > On Thursday, November 22, 2012 04:46:10 PM Adrian Hunter wrote:
> >> On 22/11/12 15:55, Chris Ball wrote:
> >>> Hi,
> >>>
> >>> On Thu, Nov 22 2012, Adrian Hunter wrote:
> >>>> Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
> >>>> so I suggest Rafael takes the patches with Chris' Ack.
> >>>>
> >>>> Please note that I would prefer this to be queued for 3.8
> >>>
> >>> Looks fine:
> >>>
> >>> Acked-by: Chris Ball <cjb@laptop.org>
> >>
> >> Thank you!
> >>
> >>>
> >>> I have some dumb questions, though -- what kind of platforms ship with
> >>> these devices?  Do they ever have the controller on PCI too, and what
> >>> happens with sdhci-pci vs. sdhci-acpi in that case?
> >>
> >> Since the arrival of ACPI5, platform devices can be configured using ACPI
> >> tables.  PCI can also be used, but the firmware ensures that the same
> >> device is not enumerated via both ACPI and PCI.
> >>
> >> Rafael can you take these patches?
> > 
> > Well, I'd prefer pnpacpi/core.c to actually use acpi_platform_device_ids[]
> > directly in addition to excluded_id_list[], so that duplicate entries don't
> > have to be added to the both of them.
> > 
> > Also, I wonder if you really don't want to use ACPI PM and if you don't,
> > then why?
> 
> Mika and Lv Zheng are working on adding it to acpi_platform

OK

Please address the Mika's comment for [3/3], though.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
