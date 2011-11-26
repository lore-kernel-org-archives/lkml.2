Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KZUpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:45:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39651 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1KZUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:45:11 -0500
Date: Sat, 26 Nov 2011 15:45:03 -0500 (EST)
Message-Id: <20111126.154503.1317670837061338352.davem@davemloft.net>
To: levinsasha928@gmail.com
Cc: linux-kernel@vger.kernel.org, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-net: Acquire device lock when releasing device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321607982-16283-1-git-send-email-levinsasha928@gmail.com>
References: <1321607982-16283-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 12:45:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 18 Nov 2011 11:19:42 +0200

> Device lock should be held when releasing a device, and specifically
> when calling vhost_dev_cleanup(). Otherwise, RCU complains about it:
 ...
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Michael et al., are you guys going to gather this fix or should I
apply it directly to thet net tree?

Thanks.
