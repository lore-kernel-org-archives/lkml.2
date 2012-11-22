Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2KVTKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:10:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:55209 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2KVTKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,301,1352102400"; 
   d="scan'208";a="221109792"
Message-ID: <50AE3AB2.2070307@intel.com>
Date: Thu, 22 Nov 2012 16:46:10 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add SDHCI ACPI driver
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com> <87k3tdagim.fsf@octavius.laptop.org>
In-Reply-To: <87k3tdagim.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/12 15:55, Chris Ball wrote:
> Hi,
> 
> On Thu, Nov 22 2012, Adrian Hunter wrote:
>> Here is SDHCI ACPI driver.  It is dependent on new ACPI Platform support
>> so I suggest Rafael takes the patches with Chris' Ack.
>>
>> Please note that I would prefer this to be queued for 3.8
> 
> Looks fine:
> 
> Acked-by: Chris Ball <cjb@laptop.org>

Thank you!

> 
> I have some dumb questions, though -- what kind of platforms ship with
> these devices?  Do they ever have the controller on PCI too, and what
> happens with sdhci-pci vs. sdhci-acpi in that case?

Since the arrival of ACPI5, platform devices can be configured using ACPI
tables.  PCI can also be used, but the firmware ensures that the same
device is not enumerated via both ACPI and PCI.

Rafael can you take these patches?

