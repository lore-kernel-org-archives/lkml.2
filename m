Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2G0Swd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:52:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2G0Swc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:52:32 -0400
Date: Fri, 27 Jul 2012 11:52:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Stiegmann <astiegmann@vmware.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
Message-ID: <20120727185228.GB25047@kroah.com>
References: <20120727181639.GA23564@kroah.com>
 <1258715407.5847225.1343414363506.JavaMail.root@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258715407.5847225.1343414363506.JavaMail.root@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 11:39:23AM -0700, Andrew Stiegmann wrote:
> 
> 
> ----- Original Message -----
> > From: "Greg KH" <gregkh@linuxfoundation.org>
> > To: "Andrew Stiegmann" <astiegmann@vmware.com>
> > Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
> > pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
> > Sent: Friday, July 27, 2012 11:16:39 AM
> > Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
> > 
> > On Fri, Jul 27, 2012 at 10:20:43AM -0700, Andrew Stiegmann wrote:
> > > > The kernel style is to use lower_case for everything.
> > > > So this would become:
> > > > 
> > > >     vmci_device_get()
> > > > 
> > > > This is obviously a very general comment and applies everywhere.
> > > 
> > > I wish I could lower case these symbols but VMCI has already
> > > existed
> > > outside the mainline Linux tree for some time now and changing
> > > these
> > > exported symbols would mean that other drivers that depend on VMCI
> > > (vSock, vmhgfs) would need to change as well.   One thought that
> > > did
> > > come to mind was exporting both VMCI_Device_Get and vmci_device_get
> > > but that would likely just confuse people.  So in short I have made
> > > function names lower case where possible, but exported symbols
> > > could
> > > not be changed.
> > 
> > Not true at all.  You want those drivers to be merged as well, right?
> > So they will need to have their functions changed, and their code as
> > well.
> 
> As previously mentioned VMware is working on upstreaming our vSock
> driver (one of a few drivers that uses vmw_vmci).

Great.

> However there are no plans to upstream the other drivers that depend
> on vmw_vmci.

Why not?  That seems quite short-sighted.

> Because of this these symbols can not change.

Then I would argue that we can not accept this code at all, because it
will change over time, both symbol names, and functionality (see my
previous comment about how that is going to have to change.)

sorry,

greg k-h
