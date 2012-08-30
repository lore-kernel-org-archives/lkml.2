Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2H3RRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:17:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37928 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2H3RRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:17:03 -0400
Date: Thu, 30 Aug 2012 13:16:59 -0400 (EDT)
Message-Id: <20120830.131659.1142504331858011461.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, jbaron@redhat.com, jim.cromie@gmail.com,
        kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] dev_<level> and dynamic_debug cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1345978012.git.joe@perches.com>
References: <cover.1345978012.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 26 Aug 2012 04:25:25 -0700

> The recent commit to fix dynamic_debug was a bit unclean.
> Neaten the style for dynamic_debug.
> Reduce the stack use of message logging that uses netdev_printk
> Add utility functions dev_printk_emit and dev_vprintk_emit for /dev/kmsg.

I think these should go through the generic device tree, feel free to
add my:

Acked-by: David S. Miller <davem@davemloft.net>
