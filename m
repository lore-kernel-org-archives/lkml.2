Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2KTSIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:08:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36113 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2KTSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:08:23 -0500
Date: Tue, 20 Nov 2012 10:08:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [Update 2][PATCH 2/3] ACPI / driver core: Introduce struct
 acpi_dev_node and related macros
Message-ID: <20121120180819.GA12328@kroah.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <6570191.KCDMiILtRE@vostro.rjw.lan>
 <20121120091007.GN17774@intel.com>
 <2800515.q4oG7o9rEp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2800515.q4oG7o9rEp@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:34:04AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / driver core: Introduce struct acpi_dev_node and related macros
> 
> To avoid adding an ACPI handle pointer to struct device on
> architectures that don't use ACPI, or generally when CONFIG_ACPI is
> not set, in which cases that pointer is useless, define struct
> acpi_dev_node that will contain the handle pointer if CONFIG_ACPI is
> set and will be empty otherwise and use it to represent the ACPI
> device node field in struct device.
> 
> In addition to that define macros for reading and setting the ACPI
> handle of a device that don't generate code when CONFIG_ACPI is
> unset.  Modify the ACPI subsystem to use those macros instead of
> referring to the given device's ACPI handle directly.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

