Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2E3Als (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:41:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:32940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2E3Alr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:41:47 -0400
Date: Tue, 29 May 2012 20:40:40 -0400 (EDT)
Message-Id: <20120529.204040.644013889059321702.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8021q/vlan: process NETDEV_GOING_DOWN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338330635-27259-1-git-send-email-eldad@fogrefinery.com>
References: <1338330635-27259-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 17:40:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Wed, 30 May 2012 00:30:35 +0200

> In the current flow, when you take down a physical device that has
> VLANs configured on it, the NETDEV_GOING_DOWN notification will be
> sent too late, i.e., no data can be sent to the wire anymore.

Why do you need to send data?  Any queued up data should be purged not
sent.
