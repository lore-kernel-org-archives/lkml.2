Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2G3XSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 19:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab2G3XSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 19:18:54 -0400
Message-ID: <1343690279.8073.215.camel@ul30vt>
Subject: Re: [GIT PULL (PATCH 0/4)] VFIO driver for v3.6
From: Alex Williamson <alex.williamson@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, benh@kernel.crashing.org, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, gregkh@linuxfoundation.org,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, ddutile@redhat.com
Date: Mon, 30 Jul 2012 17:17:59 -0600
In-Reply-To: <20120727053206.GC11870@drongo>
References: <20120725142254.12800.61860.stgit@bling.home>
	 <20120727053206.GC11870@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 15:32 +1000, Paul Mackerras wrote:
> On Wed, Jul 25, 2012 at 08:53:06AM -0600, Alex Williamson wrote:
> > Hi Linus,
> > 
> > This series includes the VFIO userspace driver interface for the
> > 3.6 kernel merge window.  This driver is intended to provide a
> > secure interface for device access using IOMMU protection for
> > applications like assignment of physical devices to virtual
> > machines.  Qemu will be the first user of this interface, enabling
> > assignment of PCI devices to Qemu guests.  This interface is
> > intended to eventually replace the x86-specific assignment mechanism
> > currently available in KVM.  This interface has the advantage of
> > being more secure, by working with IOMMU groups to ensure device
> > isolation and providing it's own filtered resource access mechanism,
> > and also more flexible, in not being x86 or KVM specific (extensions
> > to enable POWER are already working).
> > 
> > As a new driver, I'm including both the individual patches in email,
> > as well as a branch to pull from:
> > 
> > git://github.com/awilliam/linux-vfio.git for-linus
> > 
> > This driver is originally the work of Tom Lyon, but has since been
> > handed over to me and gone through a complete overhaul thanks to the
> > input from David Gibson, Ben Herrenschmidt, Chris Wright, Joerg
> > Roedel, and others.  This driver has been available in linux-next for
> > the last month.  Thanks,
> 
> Linus,
> 
> Are you thinking of pulling this driver in for 3.6?  I would be glad
> to see it go in since we want to use it with KVM on PowerPC.  If
> possible we'd like the PowerPC bits for it to go in as well.

I'm pretty anxious to find out as well.  Linus, ping, any thoughts on
including this in 3.6?  Thanks,

Alex

