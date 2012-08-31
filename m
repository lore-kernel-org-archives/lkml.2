Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2HaU2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:28:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab2HaU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:28:17 -0400
Date: Fri, 31 Aug 2012 16:28:15 -0400 (EDT)
Message-Id: <20120831.162815.212003559560432706.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] net/xfrm/xfrm_state.c: fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346258957-7649-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1346258957-7649-1-git-send-email-Julia.Lawall@lip6.fr>
	<1346258957-7649-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Wed, 29 Aug 2012 18:49:15 +0200

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize return variable before exiting on an error path.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
