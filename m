Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab2GUAtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:49:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2GUAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:49:03 -0400
Date: Fri, 20 Jul 2012 17:49:02 -0700 (PDT)
Message-Id: <20120720.174902.2055189237500355771.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCHv3 0/6] tun zerocopy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1342812067.git.mst@redhat.com>
References: <cover.1342812067.git.mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 20 Jul 2012 22:23:03 +0300

> Same as with macvtap, I get single-percentage wins in CPU utilization
> on guest to external from this patchset, and a performance regression on
> guest to host, so more work is needed until this feature can move out of
> experimental status, but I think it's useful for some people already.
> 
> Pls review and consider for 3.6.

It doesn't improve performance in one case, and hurts performance in
another.

You'll have to give me a more compelling argument than that.  You've
just given me every reason not to include these patches in 3.6

