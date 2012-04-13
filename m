Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DMRJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:09:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50744 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2DMRJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:09:52 -0400
Date: Fri, 13 Apr 2012 13:09:40 -0400 (EDT)
Message-Id: <20120413.130940.132638261191849442.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, ian.campbell@citrix.com, xma@us.ibm.com,
        shemminger@vyatta.com
Subject: Re: [PATCH] skbuff: struct ubuf_info callback type safety
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120409102402.GA5255@redhat.com>
References: <20120409102402.GA5255@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 10:09:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 9 Apr 2012 13:24:02 +0300

> The skb struct ubuf_info callback gets passed struct ubuf_info
> itself, not the arg value as the field name and the function signature
> seem to imply. Rename the arg field to ctx to match usage,
> add documentation and change the callback argument type
> to make usage clear and to have compiler check correctness.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks for fixing this Michael.
