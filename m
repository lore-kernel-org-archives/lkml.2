Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab2FWBGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 21:06:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:48170 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab2FWBGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 21:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169133295"
Subject: Re: [PATCH v5 0/13] SATA ZPODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
In-Reply-To: <4FE4BC59.20400@pobox.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	 <4FE4BC59.20400@pobox.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 23 Jun 2012 09:05:58 +0800
Message-ID: <1340413558.2672.8.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 14:41 -0400, Jeff Garzik wrote:
> On 06/18/2012 02:25 AM, Lin Ming wrote:
> > Hi all,
> >
> > This is the v5 patches to add SATA ZPODD support, to try it:
> > git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
> >
> > Holger and Mathtew,
> > Patch 1 to Patch 4 are the libata acpi binding patches from you.
> > I removed dock related code from your original version.
> > Would you help to review?
> >
> > v5:
> > - rebase to v3.5-rc3
> > - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> > - rename is_pci_ata to compat_pci_ata (Alan Cox)
> >
> > v4:
> > https://lkml.org/lkml/2012/5/28/11
> > - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> > - tell scsi layer device supports runtime power off
> > - check support for device busy class events
> 
> In the case of this patchset, the main worry are the crashes that were 
> introduced by the Macht/Garrett patchset.  Finally with v5 that 
> longstanding problem has been resolved, so we can move forward and get 
> this into linux-next (libata-dev.git#upstream).

I'm so glad to move forward.
I have some update suggested by Dan Williams, at
https://lkml.org/lkml/2012/6/21/26

I'll send out v6 for you to apply next Monday.

Thanks,
Lin Ming

> 
> 	Jeff



