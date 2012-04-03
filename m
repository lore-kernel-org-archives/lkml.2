Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2DCVtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:49:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38626 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2DCVtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:49:20 -0400
Date: Tue, 03 Apr 2012 17:49:05 -0400 (EDT)
Message-Id: <20120403.174905.769295608759578804.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org
Subject: Re: [V6 PATCH] virtio-net: send gratuitous packets when needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120328054428.34415.75432.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120328054428.34415.75432.stgit@amd-6168-8-1.englab.nay.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 14:49:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 28 Mar 2012 13:44:28 +0800

> As hypervior does not have the knowledge of guest network configuration, it's
> better to ask guest to send gratuitous packets when needed.
> 
> Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt and when it
> is set, a workqueue is scheduled to send gratuitous packet through
> NETDEV_NOTIFY_PEERS. This feature is negotiated through bit
> VIRTIO_NET_F_GUEST_ANNOUNCE.
 ...
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Michael and others, what's the story with this patch?
