Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860Ab1J1X2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:28:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933780Ab1J1X2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:28:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] PCI changes
Date: Sat, 29 Oct 2011 01:30:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20111028132935.6630b575@jbarnes-desktop>
In-Reply-To: <20111028132935.6630b575@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110290130.45150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, October 28, 2011, Jesse Barnes wrote:
> Note!  There are two branches available, see below.
> 
> The following changes since commit
> e9308cfd5ab4ade3d81cf591c7599c3a05a21b04:
> 
>   Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-10-14 17:07:52 +1200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci next-revert
> 
> Probably the most exciting bits of this series are the MPS fixes and
> Joerg's PASID stuff.  But I don't think there's anything really risky
> (i.e. no big resource management changes this time around).
> 
> We found a problem on PPC with the latency setup changes, so this
> branch includes reverts for those patches.  However, another branch is
> available with those patches rebased out if you prefer a cleaner
> changelog.  See below for the changelog and diffstat to expect from
> that branch.
> 
> Ben Hutchings (2):
>       PCI: Add Solarflare vendor ID and SFC4000 device IDs
>       PCI: Add quirk for known incorrect MPSS
> 
> Benjamin Herrenschmidt (2):
>       PCI: Make pci_setup_bridge() non-static for use by arch code
>       pci: Clamp pcie_set_readrq() when using "performance" settings
> 
> Jan Beulich (1):
>       x86: constify PCI raw ops structures
> 
> Jesse Barnes (7):
>       Revert "PCI: latency timer doesn't apply to PCIe"
>       Revert "PCI: x86: use generic pcibios_set_master()"
>       Revert "PCI: sh: use generic pcibios_set_master()"
>       Revert "PCI: mn10300: use generic pcibios_set_master()"
>       Revert "PCI: mips: use generic pcibios_set_master()"
>       Revert "PCI: frv: use generic pcibios_set_master()"
>       Revert "PCI: Pull PCI 'latency timer' setup up into the core"
> 
> Joerg Roedel (4):
>       PCI: Move ATS implementation into own file
>       PCI: Export ATS functions to modules
>       PCI: Add implementation for PRI capability
>       PCI: Add support for PASID capability
> 
> Jon Mason (3):
>       PCI: Workaround for Intel MPS errata
>       PCI: enable MPS "performance" setting to properly handle bridge MPS
>       PCI: Clean-up MPS debug output
> 
> Josh Boyer (1):
>       PCI quirk: mmc: Always check for lower base frequency quirk for Ricoh 1180:e823
> 
> Myron Stowe (7):
>       PCI: Pull PCI 'latency timer' setup up into the core
>       PCI: frv: use generic pcibios_set_master()
>       PCI: mips: use generic pcibios_set_master()
>       PCI: mn10300: use generic pcibios_set_master()
>       PCI: sh: use generic pcibios_set_master()
>       PCI: x86: use generic pcibios_set_master()
>       PCI: latency timer doesn't apply to PCIe
> 
> Prarit Bhargava (1):
>       PCI hotplug: acpiphp: Prevent deadlock on PCI-to-PCI bridge remove
> 
> Rafael J. Wysocki (2):
>       PCI / PM: Extend PME polling to all PCI devices
>       PCI / PM: Remove unnecessary error variable from acpi_dev_run_wake()

Any chance to push https://lkml.org/lkml/2011/10/21/192 any time soon?

It pretty much is a necessary fix for a problem with _OSC after some
recent changes.

Thanks,
Rafael
