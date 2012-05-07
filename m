Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2EGR6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:58:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2EGR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:58:00 -0400
Date: Mon, 07 May 2012 13:57:56 -0400 (EDT)
Message-Id: <20120507.135756.771396536686434223.davem@davemloft.net>
To: erwanaliasr1@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tshimizu818@gmail.com
Subject: Re: [PATCH] pch_gbe: Adding read memory barriers
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA80B46.5070405@gmail.com>
References: <4FA80B46.5070405@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 10:57:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your patch doesn't apply to the net-next tree which is what you should
be basing all of your networking patches on:

[davem@bql net-next]$ git am --signoff pch_gbe-Adding-read-memory-barriers.patch 
Applying: pch_gbe: Adding read memory barriers
error: patch failed: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:1222
error: drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c: patch does not apply
Patch failed at 0001 pch_gbe: Adding read memory barriers
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

Stop rushing things and take your time learning the process.

Otherwise you're going to make more work for maintainers and they
end up grumpy as a result, which you don't want.
