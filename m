Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2F0MiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:38:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23547 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2F0MiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:38:11 -0400
Date: Wed, 27 Jun 2012 15:37:34 +0300
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
Message-ID: <20120627123733.GA5449@mwanda>
References: <1340686552.1207.128.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340686552.1207.128.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 10:55:52PM -0600, Alex Williamson wrote:
> Hi,
> 
> VFIO has been kicking around for well over a year now and has been
> posted numerous times for review.  The pre-requirements are finally
> available in linux-next (or will be in the 20120626 build) so I'd like
> to request a new branch be included in linux-next with a goal of being
> accepted into v3.6.
> 

Could you run Sparse over the driver?
http://lwn.net/Articles/205624/

It reports a bunch of endian problems.  Some are definitely bugs
like:
	*prev |= cpu_to_le32((u32)epos << 20);

regards,
dan carpenter

