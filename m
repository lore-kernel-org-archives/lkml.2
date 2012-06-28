Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2F1Goy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:44:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26922 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2F1Gow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:44:52 -0400
Date: Thu, 28 Jun 2012 09:44:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        chrisw <chrisw@sous-sol.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        linux-next@vger.kernel.org
Subject: Re: Request VFIO inclusion in linux-next
Message-ID: <20120628064408.GJ3007@mwanda>
References: <1340686552.1207.128.camel@bling.home>
 <20120627123733.GA5449@mwanda>
 <1340825003.1207.224.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340825003.1207.224.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 01:23:23PM -0600, Alex Williamson wrote:
> On Wed, 2012-06-27 at 15:37 +0300, Dan Carpenter wrote:
> > On Mon, Jun 25, 2012 at 10:55:52PM -0600, Alex Williamson wrote:
> > > Hi,
> > > 
> > > VFIO has been kicking around for well over a year now and has been
> > > posted numerous times for review.  The pre-requirements are finally
> > > available in linux-next (or will be in the 20120626 build) so I'd like
> > > to request a new branch be included in linux-next with a goal of being
> > > accepted into v3.6.
> > > 
> > 
> > Could you run Sparse over the driver?
> > http://lwn.net/Articles/205624/
> > 
> > It reports a bunch of endian problems.  Some are definitely bugs
> > like:
> > 	*prev |= cpu_to_le32((u32)epos << 20);
> 
> Done.  Mostly just adding annotation, but it did find a bug or two.
> Should be cleaned up in tomorrow's next.  Thanks for the report,
> 

Cool.  I have some Smatch fixes as well.  I've updated them to apply
on top of today's linux-next.

regards,
dan carpenter

