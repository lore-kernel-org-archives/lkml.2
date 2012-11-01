Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936058Ab2KAQUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:20:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KAQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:20:08 -0400
Date: Thu, 01 Nov 2012 12:20:00 -0400 (EDT)
Message-Id: <20121101.122000.264588573091276690.davem@davemloft.net>
To: mst@redhat.com
Cc: vyasevic@redhat.com, edumazet@google.com, akpm@linux-foundation.org,
        alexander.h.duyck@intel.com, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net-next 1/8] skb: report completion status for zero
 copy skbs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121101161611.GA9410@redhat.com>
References: <0dc176ed796ff5ac7164b6c18cc75d64c2a2317e.1351679008.git.mst@redhat.com>
	<20121101.115024.1422610516561380154.davem@davemloft.net>
	<20121101161611.GA9410@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 1 Nov 2012 18:16:11 +0200

> Do you think it's over-engineering, or a good idea?

Engineer what you need, not what you might need.
