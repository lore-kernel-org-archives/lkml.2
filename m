Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2LGLLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:11:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:28405 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab2LGLLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:11:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,236,1355126400"; 
   d="scan'208";a="177449962"
Date: Fri, 7 Dec 2012 13:14:15 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add Haswell LPSS devices to
 acpi_platform_device_ids list
Message-ID: <20121207111415.GH23611@intel.com>
References: <1354874882-1162-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121207110126.53cd97e7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207110126.53cd97e7@pyramind.ukuu.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:01:26AM +0000, Alan Cox wrote:
> On Fri,  7 Dec 2012 12:08:02 +0200
> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> 
> > All devices behind Haswell LPSS (Low Power Subsystem) should be represented
> > as platform devices 
> 
> What about the bus heirarchy ? What about making sure they appear in the
> PCI resource heirarchy so we don't mash them up if we reassign or
> allocate other resources on the bus ?

I'm not sure if I understand what you mean here.

We put them in hierarchy if the parent ACPI node has also a physical device
bound to it (like PCIe root port).
