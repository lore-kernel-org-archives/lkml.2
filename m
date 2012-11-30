Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2K3RTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:19:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44628 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2K3RTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:19:39 -0500
Date: Fri, 30 Nov 2012 12:19:37 -0500 (EST)
Message-Id: <20121130.121937.1126518481722222177.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 6lowpan: consider checksum bytes in fragmentation
 threshold
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354240544-22214-1-git-send-email-alan@signal11.us>
References: <504EA95C.9010003@signal11.us>
	<1354240544-22214-1-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Thu, 29 Nov 2012 20:55:44 -0500

> Change the threshold for framentation of a lowpan packet from
> using the MTU size to now use the MTU size minus the checksum length,
> which is added by the hardware. For IEEE 802.15.4, this effectively
> changes it from 127 bytes to 125 bytes.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
