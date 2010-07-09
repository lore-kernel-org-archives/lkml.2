Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0GITTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:19:47 -0400
Received: from kroah.org ([198.145.64.141]:39830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0GITTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:19:43 -0400
Date: Fri, 9 Jul 2010 12:18:58 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 1/6] ACPI: Provide /sys/devices/system/ec/
Message-ID: <20100709191858.GC8989@kroah.com>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <1277996570-2686-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277996570-2686-2-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:02:45PM +0200, Thomas Renninger wrote:
> +config ACPI_EC_SYSFS
> +	tristate "EC read/write access through sysfs"
> +	default y
> +	help
> +	  Say N to disable Embedded Controller /sys interface
> +
> +	  An Embedded Controller typically is available on laptops and reads
> +	  sensor values like battery state and temperature.
> +	  The kernel access the EC through ACPI parsed code provided by BIOS
> +	  tables.
> +	  Thus this option is a debug option that helps to write ACPI drivers
> +	  and which can be used to identify ACPI code or EC firmware bugs.

Wait, why is this a sysfs file at all?  It should be a debugfs one,
right?

thanks,

greg k-h
