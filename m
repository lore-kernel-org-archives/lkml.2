Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1C3KtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:49:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47164
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab1C3KtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:49:01 -0400
Date: Wed, 30 Mar 2011 03:48:20 -0700 (PDT)
Message-Id: <20110330.034820.124005354.davem@davemloft.net>
To: rlandley@parallels.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.38 containers bug: Infinite loop in
 /proc/sys/net/ipv6/neigh/neigh/neigh...
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D9309B4.2000501@parallels.com>
References: <4D9302F3.6080206@parallels.com>
	<20110330.033529.71582712.davem@davemloft.net>
	<4D9309B4.2000501@parallels.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>
Date: Wed, 30 Mar 2011 05:45:08 -0500

> So you think letting it soak in the merge window and the churn of -rc1
> (which currently doesn't boot for me due to an ide issue) will provide
> more validity than a specific "There was an infinite loop in the
> filesystem, there is now no longer an infinite loop in the filesystem,
> here's the specific test for it" and visual inspection ofthe patch?

Yes I absolutely do think it's better to let it soak somewhere than
to repeat the reason why this patch is necessary in the first place.

This patch is necessary because Eric already screwed up trying to fix
this neigh dirctory under ipv6 once, and he got it wrong.

That patch looked correct and straightforward.

Yet it introduced the bug you're seeing.

Given that consideration, are you still holding steady to your
opinion wise guy? :-)

