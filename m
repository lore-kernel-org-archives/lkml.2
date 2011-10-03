Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab1JCSWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:22:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53173 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1JCSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:22:03 -0400
Date: Mon, 03 Oct 2011 14:19:51 -0400 (EDT)
Message-Id: <20111003.141951.1122469843900651595.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] virtio-net: Verify page list size before
 fitting into skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
References: <1317220855-9352-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 03 Oct 2011 11:19:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 28 Sep 2011 17:40:54 +0300

> This patch verifies that the length of a buffer stored in a linked list
> of pages is small enough to fit into a skb.
> 
> If the size is larger than a max size of a skb, it means that we shouldn't
> go ahead building skbs anyway since we won't be able to send the buffer as
> the user requested.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Michael, tell me what's happening with these two virtio-net bug fixes.

Thanks.
