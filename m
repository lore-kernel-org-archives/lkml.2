Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1CNUCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:02:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab1CNUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:02:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe native features
Date: Mon, 14 Mar 2011 21:02:11 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
References: <201103052254.48515.rjw@sisk.pl> <20110314182636.GA4069@xanatos>
In-Reply-To: <20110314182636.GA4069@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103142102.11164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 14, 2011, Sarah Sharp wrote:
> Hi Rafael,
> 
> I applied this patch, on top of this patch:
> PCI/ACPI: Report ASPM support to BIOS if not disabled from command line
> 
> Unfortunately, the Express Card still doesn't show up.  The trace looks
> slightly different, but the irq still gets disabled.  dmesg is attached.

Hmm.  It looks like, for some reason, the check against
pcie_aspm_support_enabled() returns false on your system.  Do you have
ASPM enabled in .config?

Rafael
