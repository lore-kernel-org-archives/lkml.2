Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3AIVWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:22:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab3AIVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:22:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Wed, 9 Jan 2013 21:22:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092122.08011.arnd@arndb.de>
X-Provags-ID: V02:K0:2aWtxGZjfXHJzTaOIdhFW1/IQ3Tu3+s4Oa7xzfZ4qXW
 MhMGlE1EUhE3xTfjixFeXmpsdctTp49toR0VdcP28YoX+/JIZ2
 tBCiiHWfmLxhLc4uR6Api8ff3Tq+k+jQ9pBWVaXFccG/r6QfXf
 fehg44LN1o0aZKTZ7byDNRXtkElm8nHjie432CxxHoS8oqk5Au
 nH2RGpRhNCN3wcDsp185HPC9yTCVEp/fV5kGP0F1+9/+bcJL1O
 vfuL3MWBdzijejlwGlmGQfrGVSYeaqHDGSVi9Yv1ytr8ztucgH
 OI/TzWOq6F+7ssDKOjhH/RCw5shqL+Cftn/gdskDKcimMT+epv
 rcKL4SmN4JTv6coNg9f4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Thierry Reding wrote:
> Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> directory. The motivation is to collect various host controller drivers
> in the same location in order to facilitate refactoring.
> 
> The Tegra PCIe driver has been largely rewritten, both in order to turn
> it into a proper platform driver and to add MSI (based on code by
> Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Can you split this patch into two patches, one that moves the file,
and another one that does all the changes? It's a little hard to
review when I can't easily see which code is actually new here.

	Arnd
