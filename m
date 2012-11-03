Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890Ab2KCBbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:31:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49260 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2KCBbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:31:13 -0400
Date: Fri, 02 Nov 2012 21:31:10 -0400 (EDT)
Message-Id: <20121102.213110.2070365320544608145.davem@davemloft.net>
To: mst@redhat.com
Cc: vyasevic@redhat.com, edumazet@google.com, akpm@linux-foundation.org,
        alexander.h.duyck@intel.com, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 net-next 0/8] enable/disable zero copy tx dynamically
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1351797353.git.mst@redhat.com>
References: <cover.1351797353.git.mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 1 Nov 2012 21:16:17 +0200

> 
> tun supports zero copy transmit since 0690899b4d4501b3505be069b9a687e68ccbe15b,
> however you can only enable this mode if you know your workload does not
> trigger heavy guest to host/host to guest traffic - otherwise you
> get a (minor) performance regression.
> This patchset addresses this problem by notifying the owner
> device when callback is invoked because of a data copy.
> This makes it possible to detect whether zero copy is appropriate
> dynamically: we start in zero copy mode, when we detect
> data copied we disable zero copy for a while.
> 
> With this patch applied, I get the same performance for
> guest to host and guest to guest both with and without zero copy tx.

Series applied, thanks Michael.
