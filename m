Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab2JYVXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:23:55 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56236 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab2JYVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:23:54 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2012 17:23:54 EDT
From: Dmitry Torokhov <dtor@vmware.com>
To: pv-drivers@vmware.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Bhavesh Davda <bhavesh@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, vm-crosstalk@vmware.com,
        George Zhang <georgezhang@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 04/10] VMCI: device driver implementaton.
Date: Thu, 25 Oct 2012 14:15:03 -0700
Message-ID: <13536910.geStZ41GCZ@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121025210320.GA12352@kroah.com>
References: <20121025203148.GA28096@kroah.com> <280263520.16961242.1351197830586.JavaMail.root@vmware.com> <20121025210320.GA12352@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2012 02:03:20 PM Greg KH wrote:
> On Thu, Oct 25, 2012 at 01:43:50PM -0700, Bhavesh Davda wrote:
> > Hi Greg,
> > 
> > > You can't just say "general GPL issues aside".  Honestly, given your
> > > company's prior actions in regards to Linux kernel drivers and the
> > > licenses of them, I don't trust them at all.  To help gain that trust
> > > back, marking the exports in this manner will be a great improvement.
> > 
> > You don't expect us to just let that comment slide :) Can you be more
> > specific about which "prior actions" in regards to which kernel
> > drivers, and when?
> 
> For many many years, you shipped closed source Linux kernel drivers for
> your products.  Only recently has this changed.

That was in the past. As far as I know our Linux drivers have been open
for more than 5 years, so not that recently.

Thanks,
Dmitry

