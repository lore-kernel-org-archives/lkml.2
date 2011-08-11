Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1HKRJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:09:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1HKRJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:09:36 -0400
Date: Thu, 11 Aug 2011 09:56:19 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] misc/pti.c: Fix build error when PCI is not selected
Message-ID: <20110811165619.GA11036@suse.de>
References: <20110811162306.GA30710@tj-desktop>
 <20110811094520.4ee7819f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110811094520.4ee7819f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 09:45:20AM -0700, Randy Dunlap wrote:
> On Thu, 11 Aug 2011 12:23:06 -0400 Tracey Dent wrote:
> 
> > When you try to build INTEL_MID_PTI without having PCI
> > enabled. It fails like this-
> > 
> >  CC [M]  drivers/misc/pti.o
> >  drivers/misc/pti.c: In function ‘pti_pci_remove’:
> >  drivers/misc/pti.c:410: error: implicit declaration of function ‘pci_release_region’
> >  drivers/misc/pti.c: In function ‘pti_pci_probe’:
> >  drivers/misc/pti.c:859: error: implicit declaration of function ‘pci_request_region’
> > 
> > So make INTEL_MID_PTI depend on PCI to fix build error.
> 
> I think (hope) that Greg already has a patch like this queued.
> Greg- are you planning to push some patches soon?

Yes, sorry, "real work" has been keeping me really busy at the moment,
I'll get to pushing these to Linus soon.

greg k-h
