Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2JICqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:46:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:33856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab2JICqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,556,1344236400"; 
   d="scan'208";a="232279622"
Message-ID: <1349750799.5332.1.camel@yhuang-dev>
Subject: Re: [PATCH 7/7] PM / ACPI: Take device PM QoS flags into account
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 09 Oct 2012 10:46:39 +0800
In-Reply-To: <3734460.X8hLyTaasd@vostro.rjw.lan>
References: <201209282351.10663.rjw@sisk.pl>
	 <1413438.1MkXj8vjQK@vostro.rjw.lan> <3734460.X8hLyTaasd@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 10:09 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make ACPI power management routines and PCI power management
> routines depending on ACPI take device PM QoS flags into account
> when deciding what power state to put the device into.
> 
> In particular, after this change acpi_pm_device_sleep_state() will
> not return ACPI_STATE_D3_COLD as the deepest available low-power
> state if PM_QOS_FLAG_NO_POWER_OFF is requested for the device and it
> will not require remote wakeup to work for the device in the returned
> low-power state if there is at least one PM QoS flags request for the
> device, but PM_QOS_FLAG_REMOTE_WAKEUP is not requested for it.
> 
> Accordingly, acpi_pci_set_power_state() will refuse to put the
> device into D3cold if PM_QOS_FLAG_NO_POWER_OFF is requested for it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Jean Pihet <j-pihet@ti.com>

Reviewed-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


