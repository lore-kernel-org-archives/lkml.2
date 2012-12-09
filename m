Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2LIFcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 00:32:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42139 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2LIFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 00:32:22 -0500
Date: Sun, 09 Dec 2012 00:32:19 -0500 (EST)
Message-Id: <20121209.003219.740497965401517120.davem@davemloft.net>
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

These changes look fine to me, applied, thanks.
