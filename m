Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab0GTUYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:24:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:46047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab0GTUYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:24:36 -0400
Date: Tue, 20 Jul 2010 13:20:30 -0700
From: Greg KH <gregkh@suse.de>
To: Piotr Jaroszy??ski <p.jaroszynski@gmail.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100720202030.GC11991@suse.de>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com> <AANLkTin4aU9GtC8zOuQcCRAQsWb_ndih3c6URlpE4ODI@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin4aU9GtC8zOuQcCRAQsWb_ndih3c6URlpE4ODI@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 10:45:23AM +0200, Piotr Jaroszy??ski wrote:
> On 16 July 2010 23:58, Tom Lyon <pugs@cisco.com> wrote:
> > The VFIO "driver" is used to allow privileged AND non-privileged processes to
> > implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> > devices.
> 
> Thanks for working on that! I wonder whether it's possible to say what
> are the chances of it being merged to mainline and which version we
> might be talking about?

We still have a long way to go before you need to worry about what
kernel version it's going to show up in...

thanks,

greg k-h
