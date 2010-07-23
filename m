Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab0GWRnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab0GWRnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:43:49 -0400
Date: Fri, 23 Jul 2010 10:42:57 -0700
From: Chris Wright <chrisw@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, ddutile@redhat.com,
        bjorn.helgaas@hp.com, eike-kernel@sf-tec.de
Subject: Re: [PATCH v2] pci: Allow read/write access to sysfs I/O port
 resources
Message-ID: <20100723174257.GZ2651@x200.localdomain>
References: <20100719031148.13524.25354.stgit@localhost6.localdomain6>
 <20100719154321.11535.39055.stgit@localhost6.localdomain6>
 <1279897827.4601.89.camel@x201>
 <20100723092806.58ef884f@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723092806.58ef884f@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes (jbarnes@virtuousgeek.org) wrote:
> On Fri, 23 Jul 2010 09:10:27 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Mon, 2010-07-19 at 09:45 -0600, Alex Williamson wrote:
> > > PCI sysfs resource files currently only allow mmap'ing.  On x86 this
> > > works fine for memory backed BARs, but doesn't work at all for I/O
> > > port backed BARs.  Add read/write to I/O port PCI sysfs resource
> > > files to allow userspace access to these device regions.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > 
> > Any thoughts on this for -next?  Thanks,
> 
> Yeah, I like it.  Unless there are objections I'll pull it in.

Acked-by: Chris Wright <chrisw@redhat.com>

I think we may have some room for follow-on cleanups so consolidate the
ioport read/write functions w/ other HAVE_PCI_LEGACY bits...

thanks,
-chris
