Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2GKGgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:36:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44417 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2GKGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:36:39 -0400
Date: Tue, 10 Jul 2012 23:36:38 -0700 (PDT)
Message-Id: <20120710.233638.1081913772093556666.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120710130848.1014fbe05e5146a33a3c7d39@canb.auug.org.au>
References: <20120710130848.1014fbe05e5146a33a3c7d39@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 10 Jul 2012 13:08:48 +1000

> I added the following merge fix patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 10 Jul 2012 13:06:01 +1000
> Subject: [PATCH] net: fix for qmi_wwan_unbind_shared changes
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen, I'll incorporate this when I merge net into net-next.

Thanks again!
