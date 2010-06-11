Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0FKEU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 00:20:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:46902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0FKEUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 00:20:55 -0400
Date: Thu, 10 Jun 2010 21:19:51 -0700
From: Greg KH <gregkh@suse.de>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100611041951.GA23796@suse.de>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
 <20100610172736.GA9737@phenom.dumpdata.com>
 <201006101858.38491.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006101858.38491.pugs@lyon-about.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 06:58:37PM -0700, Tom Lyon wrote:
> On Thursday 10 June 2010 10:27:36 am Konrad Rzeszutek Wilk wrote:
> > > +EXPORT_SYMBOL(uiommu_fdget);
> > 
> > EXPORT_SYMBOL_GPL
> > .. snip
> > > +EXPORT_SYMBOL(uiommu_put);
> > 
> > ditto.
> > 
> 
> Is there a definitive explanation somewhere of when to use each?

For a driver like this, that is very tied to the way that the kernel
works, I would recommend the _GPL marking, like the UIO interface has.

But that's just me. :)

thanks,

greg k-h
