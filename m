Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3AICWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:22:07 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:48257 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203Ab3AICWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:22:05 -0500
Date: Tue, 8 Jan 2013 18:22:04 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
Message-ID: <20130109022204.GA22875@dtor-ws.eng.vmware.com>
References: <20130109002110.GB5296@kroah.com>
 <20130108.173056.1029788106028104571.davem@davemloft.net>
 <1683801.VNKd61ZM1Q@dtor-d630.eng.vmware.com>
 <20130108.174601.1788895671912734725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108.174601.1788895671912734725.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 05:46:01PM -0800, David Miller wrote:
> From: Dmitry Torokhov <dtor@vmware.com>
> Date: Tue, 08 Jan 2013 17:41:44 -0800
> 
> > On Tuesday, January 08, 2013 05:30:56 PM David Miller wrote:
> >> From: Greg KH <gregkh@linuxfoundation.org>
> >> Date: Tue, 8 Jan 2013 16:21:10 -0800
> >> 
> >> > On Tue, Jan 08, 2013 at 03:59:08PM -0800, George Zhang wrote:
> >> >> * * *
> >> >> 
> >> >> This series of VSOCK linux upstreaming patches include latest udpate from
> >> >> VMware to address Greg's and all other's code review comments.
> >> > 
> >> > Dave, you acked these patches a while ago,
> >> 
> >> Really?  I'd like to see where I did that.
> >> 
> >> Instead, what I remember doing was deferring to the feedback these
> >> folks received, stating that ideas that the virtio people had
> >> mentioned should be considered instead.
> >> 
> >> http://marc.info/?l=linux-netdev&m=135301515818462&w=2
> > 
> > I believe Andy replied to Anthony's AF_VMCHANNEL post and the differences
> > between the proposed solutions.
> 
> I'd much rather see a hypervisor neutral solution than a hypervisor
> specific one which this certainly is.

Objectively speaking neither solution is hypervisor neutral as there are
hypervisors that implement either VMCI or virtio or something else
entirely.

Our position is that VSOCK feature set is more complete and that it
should be possible to use transports other than VMCI for VSOCK traffic,
should interested parties implement them, and on this basis we ask to
include VSOCK.

Thanks,
Dmitry
