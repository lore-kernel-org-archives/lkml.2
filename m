Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab2IUBvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:51:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:21226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab2IUBvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,458,1344236400"; 
   d="scan'208";a="147396611"
Message-ID: <1348192250.8212.233.camel@yhuang-dev>
Subject: Re: [RFC 3/3] PCI/PM: Disable PME poll for PCIe devices
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Fri, 21 Sep 2012 09:50:50 +0800
In-Reply-To: <201209202131.13483.rjw@sisk.pl>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
	 <1347872076-5260-4-git-send-email-ying.huang@intel.com>
	 <201209202131.13483.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 21:31 +0200, Rafael J. Wysocki wrote:
> On Monday, September 17, 2012, Huang Ying wrote:
> > PME poll is not necessary for PCIe devices, because PCIe devices use
> > in-band PME message and IRQ on PCIe port to report PME.
> 
> Alas, not all of them as it turns out and even if they do, it doesn't
> work for some of them. That's why we've added the PCIe devices polling
> (quite recently, for that matter).
> 
> If you'd spent some time on some proper research regarding that (like browsing
> the changelogs of git commits modifying the relevant part of drivers/pci/pci.c),
> you'd have known that already.
> 
> And that actually is quite important, because I don't have to remember every
> single PM-related change we're making in the PCI layer.  I _incidentally_ do
> remember this one, but that may not happen next time.  Please do the research
> _before_ proposing changes of this kind.

Sorry.  I should have done more research before sending the patch out.
Will do more research next time.

Best Regards,
Huang Ying


