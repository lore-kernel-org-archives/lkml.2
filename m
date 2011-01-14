Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1ANThf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:37:35 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:44720 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1ANThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:37:34 -0500
Date: Fri, 14 Jan 2011 20:37:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git pull] PCI changes (link error)
Message-ID: <20110114193731.GA2381@gentoo.trippels.de>
References: <20110114090150.0a212030@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114090150.0a212030@jbarnes-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.01.14 at 09:01 -0800, Jesse Barnes wrote:
> ...
> 
> Rafael J. Wysocki (5):
>       PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
>       PCI/PCIe: Clear Root PME Status bits early during system resume
>       PCI/ACPI: Request _OSC control once for each root bridge (v3)

This breaks the build if CONFIG_PCIEPORTBUS is not set:

ld: drivers/built-in.o: in function acpi_pci_root_add:pci_root.c(.devinit.text+0x2633): error: undefined reference to 'pcie_ports_disabled'

-- 
Markus
