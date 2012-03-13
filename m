Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2CMAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:07:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53049 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab2CMAHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:07:04 -0400
Date: Mon, 12 Mar 2012 17:06:58 -0700 (PDT)
Message-Id: <20120312.170658.1637379523228794072.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 0/2] net/hyperv: Add support for vlan trunking from
 guests
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331583650-29686-1-git-send-email-haiyangz@microsoft.com>
References: <1331583650-29686-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 17:06:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 12 Mar 2012 13:20:48 -0700

> This patch series add vlan trunking feature from guests. With this feature,
> a Linux guest can now configure multiple vlans through a single synthetic
> NIC on Win8 Hyper-V host.
> 
> Note: Both patches should go to the 'net-next' tree. The patch [1/2] is
> required by the vlan trunking feature [2/2]. So they should go together.
> 
> The bug in rndis_filter_receive() does NOT happen until we start to use 
> 'per-packet-data' by the vlan trunking feature, so the bug fix [1/2] isn't
> urgent to be applied into 'net' tree.

Both applied, thanks.
