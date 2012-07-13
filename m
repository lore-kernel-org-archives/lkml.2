Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2GMINx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:13:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:57671 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2GMINj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165344814"
Date: Fri, 13 Jul 2012 11:15:37 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, rui.zhang@intel.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/12] ACPI: add module_acpi_driver() and convert drivers
 to it
Message-ID: <20120713081537.GN25330@intel.com>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 01:59:19PM +0300, Mika Westerberg wrote:
> This is similar than what is done for other busses before (PCI, I2C, SPI,
> platform). It reduces a lot of unnecessary boilerplate code from modules.
> 
> We also remove following redundant check on few drivers:
> 
> 	if (acpi_disabled)
> 		return -ENODEV;
> 
> as this same check is already done at the beginning of
> acpi_bus_register_driver().
> 
> I think these should all go via ACPI tree because they all depend on the
> first patch which adds the macro to the ACPI subsystem.

Len, do you have any comments? Could you consider merging these patches?

Thanks.
