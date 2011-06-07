Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1FGPLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:11:19 -0400
Received: from sous-sol.org ([216.99.217.87]:44456 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755431Ab1FGPLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:11:17 -0400
Date: Tue, 7 Jun 2011 08:10:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
        padmanabh ratnakar <pratnakarlx@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu <iommu@lists.linux-foundation.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: Seeing DMAR errors after multiple load/unload with SR-IOV
Message-ID: <20110607151032.GZ23047@sequoia.sous-sol.org>
References: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
 <1307398661.5901.14.camel@x201>
 <20110606223451.GW23047@sequoia.sous-sol.org>
 <BANLkTintUEWqwhUmR2MYC0jixqEi-wNJpg@mail.gmail.com>
 <20110607133804.GX23047@sequoia.sous-sol.org>
 <1307454415.24181.46.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307454415.24181.46.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Tue, 2011-06-07 at 06:38 -0700, Chris Wright wrote:
> > I think we still leak the list entry though.  Bottom line is that we
> > need to handle hotplug ADD_DEVICE and DEL_DEVICE notifications.  We
> > happen to pick up ADD_DEVICE by accident, but it's all pretty sloppy. 
> 
> Yeah, keeping a list of possible stale 'pci_dev' pointers is stupid. We
> should figure out the matching DMAR unit directly from the ACPI table at
> ADD_DEVICE time, and store it in pdev->archdata.iommu.
> 
> I saw patches which were going in that direction...

Cool, where are they?  I'm working on something similar, and missed them.

thanks,
-chris
