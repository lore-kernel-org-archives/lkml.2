Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3AIA2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:28:53 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:51126 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455Ab3AIA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:28:52 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: pv-drivers@vmware.com
Cc: Greg KH <gregkh@linuxfoundation.org>,
        George Zhang <georgezhang@vmware.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 07/12] VMCI: queue pairs implementation.
Date: Tue, 08 Jan 2013 16:28:51 -0800
Message-ID: <2526541.2xuuOB7vZK@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.4 (Linux/3.7.0+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20130109001539.GA24989@kroah.com>
References: <20130108234751.2698.66606.stgit@promb-2n-dhcp175.eng.vmware.com> <20130108235444.2698.24076.stgit@promb-2n-dhcp175.eng.vmware.com> <20130109001539.GA24989@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday, January 08, 2013 04:15:39 PM Greg KH wrote:
> On Tue, Jan 08, 2013 at 03:54:54PM -0800, George Zhang wrote:
> 
> > +/* Guest device port I/O. */
> > +struct PPNSet {
> > +	u64 num_produce_pages;
> > +	u64 num_consume_pages;
> > +	u32 *produce_ppns;
> > +	u32 *consume_ppns;
> > +	bool initialized;
> > +};
> 
> I know this is a private structure to the driver, so it's not that big
> of a deal at all, but the naming for this is a bit odd (mixed case.)
> 
> Not a show stopper at all, but if you had run checkpatch.pl on it, it
> would have warned you about this.

Surprisingly it does not:

[dtor@dtor-ws vmci]$ ./scripts/checkpatch.pl -f  
drivers/misc/vmw_vmci/vmci_queue_pair.h 
total: 0 errors, 0 warnings, 191 lines checked

drivers/misc/vmw_vmci/vmci_queue_pair.h has no obvious style problems and is 
ready for submission.

Also silent on the patch itself...

We'll send a followup patch anyway.

Thanks,
Dmitry

