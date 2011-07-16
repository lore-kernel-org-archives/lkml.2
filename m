Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1GPXiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:38:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:47441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1GPXiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:38:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,215,1309762800"; 
   d="scan'208";a="26681031"
Date: Sun, 17 Jul 2011 00:39:38 +0100
From: Alan Cox <alan@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110717003938.375976aa@bob.linux.org.uk>
In-Reply-To: <20110716231511.394534c7936a65d70a0a3ce6@canb.auug.org.au>
References: <20110716231511.394534c7936a65d70a0a3ce6@canb.auug.org.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 23:15:11 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/video/Kconfig:36:error: recursive dependency detected!
> drivers/video/Kconfig:36:	symbol FB is selected by
> DRM_KMS_HELPER drivers/gpu/drm/Kconfig:22:	symbol
> DRM_KMS_HELPER is selected by DRM_PSB
> drivers/staging/gma500/Kconfig:1:	symbol DRM_PSB depends on
> ACPI_VIDEO
> 
> Caused by commit 66dca5178c70 ("gma500: Fix dependencies").

Can you drop that one of your tree Greg - duplicated here and I need to
think somewhat harder about how we sort that out.
