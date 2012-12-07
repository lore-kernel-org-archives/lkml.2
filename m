Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424288Ab2LGUgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:36:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58623 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424123Ab2LGUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:36:01 -0500
Date: Fri, 07 Dec 2012 15:35:56 -0500 (EST)
Message-Id: <20121207.153556.989159003987459765.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, krkumar2@in.ibm.com, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [PATCH net-next v3 0/3] Multiqueue support in virtio-net
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
References: <1354899897-10423-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Sat,  8 Dec 2012 01:04:54 +0800

> This series is an update version (hope the final version) of multiqueue
> (VIRTIO_NET_F_MQ) support in virtio-net driver. All previous comments were
> addressed, the work were based on Krishna Kumar's work to let virtio-net use
> multiple rx/tx queues to do the packets reception and transmission. Performance
> test show the aggregate latency were increased greately but may get some
> regression in small packet transmission. Due to this, multiqueue were disabled
> by default. If user want to benefit form the multiqueue, ethtool -L could be
> used to enable the feature.
> 
> Please review and comments.
> 
> A protype implementation of qemu-kvm support could by found in
> git://github.com/jasowang/qemu-kvm-mq.git. To start a guest with two queues, you
> could specify the queues parameters to both tap and virtio-net like:
> 
> ./qemu-kvm -netdev tap,queues=2,... -device virtio-net-pci,queues=2,...
> 
> then enable the multiqueue through ethtool by:
> 
> ethtool -L eth0 combined 2

It seems like most, if not all, of the feedback given for this series
has been addressed by Jason.

Can I get some ACKs?

Thanks.
