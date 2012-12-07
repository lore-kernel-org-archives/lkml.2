Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2LGXNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:13:41 -0500
Received: from mail.vyatta.com ([76.74.103.46]:41797 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab2LGXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:13:40 -0500
Date: Fri, 7 Dec 2012 15:13:30 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: jasowang@redhat.com, krkumar2@in.ibm.com, kvm@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bhutchings@solarflare.com,
        jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [PATCH net-next v3 0/3] Multiqueue support in virtio-net
Message-ID: <20121207151330.3cd111a4@samsung-9>
In-Reply-To: <20121207.153556.989159003987459765.davem@davemloft.net>
References: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
	<20121207.153556.989159003987459765.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 15:35:56 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: Jason Wang <jasowang@redhat.com>
> Date: Sat,  8 Dec 2012 01:04:54 +0800
> 
> > This series is an update version (hope the final version) of multiqueue
> > (VIRTIO_NET_F_MQ) support in virtio-net driver. All previous comments were
> > addressed, the work were based on Krishna Kumar's work to let virtio-net use
> > multiple rx/tx queues to do the packets reception and transmission. Performance
> > test show the aggregate latency were increased greately but may get some
> > regression in small packet transmission. Due to this, multiqueue were disabled
> > by default. If user want to benefit form the multiqueue, ethtool -L could be
> > used to enable the feature.
> > 
> > Please review and comments.
> > 
> > A protype implementation of qemu-kvm support could by found in
> > git://github.com/jasowang/qemu-kvm-mq.git. To start a guest with two queues, you
> > could specify the queues parameters to both tap and virtio-net like:
> > 
> > ./qemu-kvm -netdev tap,queues=2,... -device virtio-net-pci,queues=2,...
> > 
> > then enable the multiqueue through ethtool by:
> > 
> > ethtool -L eth0 combined 2
> 
> It seems like most, if not all, of the feedback given for this series
> has been addressed by Jason.
> 
> Can I get some ACKs?

Other than the minor style nit in the first patch, I see no issues.
This is really needed by Virtual Routers.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>

