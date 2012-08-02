Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2HBHVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:21:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53144 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2HBHVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:21:08 -0400
Date: Thu, 02 Aug 2012 00:21:07 -0700 (PDT)
Message-Id: <20120802.002107.240245942153879823.davem@davemloft.net>
To: jj@chaosbits.net
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: fix mem leak when command is unknown
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1207312337590.7100@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207312337590.7100@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Tue, 31 Jul 2012 23:39:37 +0200 (CEST)

> In bnx2x_mcast_enqueue_cmd() we'll leak the memory allocated to
> 'new_cmd' if we hit the deafault case of the 'switch (cmd)'.
> Add a 'kfree(new_cmd)' to that case to avoid the leak.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
