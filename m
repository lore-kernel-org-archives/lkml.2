Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab0EFU3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:29:49 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:36231 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab0EFU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:29:47 -0400
Date: Thu, 06 May 2010 16:29:42 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 6 (acpi: PCI=n)
In-reply-to: <20100506080722.3b724475.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.00.1005061628070.12696@localhost.localdomain>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
 <20100506080722.3b724475.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When CONFIG_PCI is not enabled:
> 
> arch/x86/kernel/acpi/boot.c:1034: error: 'pci_bus_type' undeclared
> 
> drivers/acpi/reboot.c:30: error:implicit declaration of function 'pci_find_bus'
> drivers/acpi/reboot.c:30: warning: assignment makes pointer from integer without a cast
> drivers/acpi/reboot.c:38: error:implicit declaration of function 'pci_bus_write_config_byte'

CONFIG_ACPI depends on CONFIG_PCI, so this file should not be build with 
CONFIG_PCI=n.

Please let me know how you were able to generate this illegal 
configuration.

thanks,
Len Brown, Intel Open Source Technology Center

