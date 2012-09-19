Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2ISUAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:00:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56991 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2ISUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:00:11 -0400
Date: Wed, 19 Sep 2012 16:00:09 -0400 (EDT)
Message-Id: <20120919.160009.1489407274317336389.davem@davemloft.net>
To: ecashin@coraid.com
Cc: akpm@linux-foundation.org, jesse@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: do not disable sg for AoE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348079358.4585@cat.he.net>
References: <1348079358.4585@cat.he.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Tue, 18 Sep 2012 20:20:36 -0400

Please do not incorporate the date of the commit in your local tree
into the Date: field advertised in your outgoing emails when you post
patches.

You did not post this on September 18th, you posted it on September
19th.

When you post patches the way you did, it screws up the ordering
of my patch queue at:

	http://patchwork.ozlabs.org/project/netdev/list/

since it is sorted by the Date: in the patch's email.

Therefore if you just use the normal email posting date it makes
my life a lot easier and it makes sure patches will be looked at
and processed in the correct order.

Thanks.
