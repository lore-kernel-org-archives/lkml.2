Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3AIBlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:41:46 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:46461 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096Ab3AIBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:41:45 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: pv-drivers@vmware.com
Cc: David Miller <davem@davemloft.net>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
Date: Tue, 08 Jan 2013 17:41:44 -0800
Message-ID: <1683801.VNKd61ZM1Q@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.4 (Linux/3.7.0+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <20130108.173056.1029788106028104571.davem@davemloft.net>
References: <20130108235633.3719.6085.stgit@promb-2n-dhcp175.eng.vmware.com> <20130109002110.GB5296@kroah.com> <20130108.173056.1029788106028104571.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 08, 2013 05:30:56 PM David Miller wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Tue, 8 Jan 2013 16:21:10 -0800
> 
> > On Tue, Jan 08, 2013 at 03:59:08PM -0800, George Zhang wrote:
> >> * * *
> >> 
> >> This series of VSOCK linux upstreaming patches include latest udpate from
> >> VMware to address Greg's and all other's code review comments.
> > 
> > Dave, you acked these patches a while ago,
> 
> Really?  I'd like to see where I did that.
> 
> Instead, what I remember doing was deferring to the feedback these
> folks received, stating that ideas that the virtio people had
> mentioned should be considered instead.
> 
> http://marc.info/?l=linux-netdev&m=135301515818462&w=2

I believe Andy replied to Anthony's AF_VMCHANNEL post and the differences
between the proposed solutions.

> 
> So definitely NACK this code and any infrastructure you've
> merged which essentialy depends upon it.

No, there is no infrastructure that depends on VSOCK, as VSOCK is built
on top of VMCI, not the other way around.

Thanks,
Dmitry

