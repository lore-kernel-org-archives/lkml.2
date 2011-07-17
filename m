Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1GQTxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 15:53:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59716 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab1GQTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 15:53:20 -0400
Date: Sun, 17 Jul 2011 12:53:14 -0700 (PDT)
Message-Id: <20110717.125314.2233794351034635919.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9] vhost: experimental tx zero-copy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110717193540.GA29392@redhat.com>
References: <20110717193540.GA29392@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 17 Jul 2011 12:53:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 17 Jul 2011 22:36:14 +0300

> The below is what I came up with. We add the feature enabled
> by default ...

s/enabled/disabled/  Well, at least you got it right in the
commit message where it counts :-)
