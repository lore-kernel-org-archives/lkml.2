Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936868Ab0COViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:38:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35340
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222Ab0COVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:38:45 -0400
Date: Mon, 15 Mar 2010 14:39:06 -0700 (PDT)
Message-Id: <20100315.143906.150716862.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       roger.oksanen@cs.helsinki.fi
Subject: Re: [Stable-review] [19/39] e100: Use pci pool to work around
 GFP_ATOMIC order 5 memory allocation failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100315143653.294c0650@nehalam>
References: <20100315142953.7aae4395@nehalam>
	<20100315.143225.212581877.davem@davemloft.net>
	<20100315143653.294c0650@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 15 Mar 2010 14:36:53 -0700

> The kernel has both fixes in it. The customer reported that if both
> were reverted, the kernel panic went away.

Please recheck that as your backtrace matches exactly the
crash signature fixed by the memset().
