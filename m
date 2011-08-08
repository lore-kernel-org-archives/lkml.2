Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1HHFa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:30:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56875 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1HHFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:30:55 -0400
Date: Sun, 07 Aug 2011 22:29:41 -0700 (PDT)
Message-Id: <20110807.222941.1783212172392022233.davem@davemloft.net>
To: prox@prolixium.com
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/usb: Add IPv6 support to the LG-VL600 LTE USB
 modem driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312669694-28800-1-git-send-email-prox@prolixium.com>
References: <1312669694-28800-1-git-send-email-prox@prolixium.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 22:29:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Kamichoff <prox@prolixium.com>
Date: Sat,  6 Aug 2011 18:28:14 -0400

> The LG-VL600 LTE USB modem supports IPv6, but uses and expects an IPv4
> ethertype (0x800) for these packets instead of the standard 0x86dd.
> This patch peeks at the IP version in the L3 header and sets the
> ethertype appropriately for IPv6 packets.
> 
> Signed-off-by: Mark Kamichoff <prox@prolixium.com>

Applied, thanks.
