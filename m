Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2GBDWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:22:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:15608 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2GBDWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:22:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117967693"
Subject: Re: linux-next: build warnings after merge of the libata tree
From: Lin Ming <ming.m.lin@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>
In-Reply-To: <20120702131914.510857dc84182e95641e7e97@canb.auug.org.au>
References: <20120702131914.510857dc84182e95641e7e97@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jul 2012 11:21:58 +0800
Message-ID: <1341199318.31272.2.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 13:19 +1000, Stephen Rothwell wrote:
> Hi Jeff,
> 
> After merging the libata tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
> drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
> drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
> drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not used [-Wunused-function]
> drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used [-Wunused-function]
> drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not used [-Wunused-function]
> 
> Introduced by commits 6b66d95895c1 ("libata: bind the Linux device tree
> to the ACPI device tree") and 3bd46600a7a7 ("libata-acpi: add ata port
> runtime D3Cold support").  Several "inline"s missing ...
> 

Hi Stephen,

Could you please send me your ppc64 .config?
I'll do cross build on my x86 machine.

Thanks,
Lin Ming

