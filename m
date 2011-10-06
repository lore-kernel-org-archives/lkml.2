Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab1JFTnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:43:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab1JFTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:43:15 -0400
Date: Thu, 06 Oct 2011 15:41:05 -0400 (EDT)
Message-Id: <20111006.154105.273839447525115710.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 06 Oct 2011 12:41:09 -0700 (PDT)
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

Applied to net-next
