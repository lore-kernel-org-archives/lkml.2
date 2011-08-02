Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1HBQZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:25:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab1HBQZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:25:12 -0400
Date: Tue, 2 Aug 2011 09:24:17 -0700
From: Greg KH <gregkh@suse.de>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
Message-ID: <20110802162417.GA1101@suse.de>
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com>
 <20110802081129.b84a7bc7.rdunlap@xenotime.net>
 <4E382329.8080307@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E382329.8080307@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 09:17:45AM -0700, J Freyensee wrote:
> On 08/02/2011 08:11 AM, Randy Dunlap wrote:
> >On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:
> >
> >>From: Heiko Carstens<heiko.carstens@de.ibm.com>
> >>
> >>allmodconfig compile fails on s390 because of the new PTI driver:
> >>
> >>drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
> >>drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
> >>
> >>Add a 'depends on PCI' statement so it doesn't get compiled.
> >>
> >>Cc: J Freyensee<james_p_freyensee@linux.intel.com>
> >
> 
> Greg, did you see the patch go your way?
> 
> http://marc.info/?l=linux-kernel&m=131007615706260&w=2
> 
> Should I res-submit this patch to you through the linux-next mailing list?

I'll pick it up, it's in my "to-apply" queue now.

thanks,

greg k-h
