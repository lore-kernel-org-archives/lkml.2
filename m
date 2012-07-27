Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2G0AB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:01:27 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54536 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab2G0AB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:01:26 -0400
Date: Thu, 26 Jul 2012 17:01:26 -0700 (PDT)
From: Andrew Stiegmann <astiegmann@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
Message-ID: <1313122679.5122648.1343347286224.JavaMail.root@vmware.com>
In-Reply-To: <20120726234850.GB3849@kroah.com>
Subject: Re: [vmw_vmci 01/11] Apply VMCI context code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed.  Thanks.

----- Original Message -----
> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
> Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
> vm-crosstalk@vmware.com, cschamp@vmware.com
> Sent: Thursday, July 26, 2012 4:48:50 PM
> Subject: Re: [vmw_vmci 01/11] Apply VMCI context code
> 
> On Thu, Jul 26, 2012 at 04:39:30PM -0700, Andrew Stiegmann (stieg)
> wrote:
> > Context code maintains state for vmci and allows the driver
> > to communicate with multiple VMs.
> > 
> > Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
> 
> One tiny nit:
> 
> > diff --git a/drivers/misc/vmw_vmci/vmci_context.c
> > b/drivers/misc/vmw_vmci/vmci_context.c
> > new file mode 100644
> > index 0000000..46faf10
> > --- /dev/null
> > +++ b/drivers/misc/vmw_vmci/vmci_context.c
> > @@ -0,0 +1,1269 @@
> > +/*
> > + * VMware VMCI Driver
> > + *
> > + * Copyright (C) 2012 VMware, Inc. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify it
> > + * under the terms of the GNU General Public License as published
> > by the
> > + * Free Software Foundation version 2 and no later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > MERCHANTABILITY
> > + * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
> > Public License
> > + * for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License along
> > + * with this program; if not, write to the Free Software
> > Foundation, Inc.,
> > + * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
> 
> Are you prepared to track the office movements of the FSF for the
> next
> 40 years to keep this up to date?  If not, please don't include it,
> it's
> not needed at all.
> 
> greg k-h
> 
