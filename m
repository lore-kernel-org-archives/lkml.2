Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2FYXEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:04:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2FYXEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:04:38 -0400
Date: Mon, 25 Jun 2012 16:04:37 -0700 (PDT)
Message-Id: <20120625.160437.1414802196489079213.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120625133318.a57079c86bad4360828efac0@canb.auug.org.au>
References: <20120625133318.a57079c86bad4360828efac0@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Jun 2012 13:33:18 +1000

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/usb/qmi_wwan.c between commit b9f90eb27402 ("net: qmi_wwan:
> fix Gobi device probing") from the net tree and various commits from the
> net-next tree.
> 
> I am not sure how to fix this, but the comments in the net tree commit
> implied that it would be placed in the 3.6 code, so I just used the
> version of this file from the net-next tree.

I've resolved this during today's net --> net-next merge.
