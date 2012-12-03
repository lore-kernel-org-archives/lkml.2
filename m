Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2LCSmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:42:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39293 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2LCSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:42:40 -0500
Date: Mon, 03 Dec 2012 13:42:38 -0500 (EST)
Message-Id: <20121203.134238.1861170350026259675.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: initialize zcopy packet counters
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121203173151.GA30949@redhat.com>
References: <20121203173151.GA30949@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 3 Dec 2012 19:31:51 +0200

> These packet counters are used to drive the zercopy
> selection heuristic so nothing too bad happens if they are off a bit -
> and they are also reset once in a while.
> But it's cleaner to clear them when backend is set so that
> we start in a known state.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied to net-next, thanks.
