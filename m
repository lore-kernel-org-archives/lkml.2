Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2JGSnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:43:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44733 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2JGSnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:43:23 -0400
Date: Sun, 07 Oct 2012 14:43:19 -0400 (EDT)
Message-Id: <20121007.144319.1790853256019640271.davem@davemloft.net>
To: ramesh.nagappa@gmail.com
Cc: netdev@vger.kernel.org, edumazet@google.com, ebiederm@xmission.com,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        ramesh.nagappa@ericsson.com
Subject: Re: [PATCH V2] net: Fix skb_under_panic oops in
 neigh_resolve_output
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349500215-22765-1-git-send-email-ramesh.nagappa@gmail.com>
References: <1349500215-22765-1-git-send-email-ramesh.nagappa@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ramesh.nagappa@gmail.com
Date: Fri,  5 Oct 2012 22:10:15 -0700

> The retry loop in neigh_resolve_output() and neigh_connected_output()
> call dev_hard_header() with out reseting the skb to network_header.
> This causes the retry to fail with skb_under_panic. The fix is to
> reset the network_header within the retry loop.
> 
> Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
> Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
> Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
> Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>

Applied and queued up for -stable, thanks.
