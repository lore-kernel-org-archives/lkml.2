Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030Ab2KAPud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:50:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KAPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:50:28 -0400
Date: Thu, 01 Nov 2012 11:50:24 -0400 (EDT)
Message-Id: <20121101.115024.1422610516561380154.davem@davemloft.net>
To: mst@redhat.com
Cc: vyasevic@redhat.com, edumazet@google.com, akpm@linux-foundation.org,
        alexander.h.duyck@intel.com, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net-next 1/8] skb: report completion status for zero
 copy skbs
From: David Miller <davem@davemloft.net>
In-Reply-To: <0dc176ed796ff5ac7164b6c18cc75d64c2a2317e.1351679008.git.mst@redhat.com>
References: <cover.1351679008.git.mst@redhat.com>
	<0dc176ed796ff5ac7164b6c18cc75d64c2a2317e.1351679008.git.mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 31 Oct 2012 12:31:06 +0200

> -void vhost_zerocopy_callback(struct ubuf_info *ubuf)
> +void vhost_zerocopy_callback(struct ubuf_info *ubuf, int zerocopy_status)

If you're only reporting true/false values, even just for now,
please use 'bool' for this.
