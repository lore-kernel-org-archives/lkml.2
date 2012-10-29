Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab2J2SGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:06:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab2J2SGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:06:34 -0400
Date: Mon, 29 Oct 2012 14:06:32 -0400 (EDT)
Message-Id: <20121029.140632.231750343803161384.davem@davemloft.net>
To: rob.herring@calxeda.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jonathan@jonmasters.org, eric.dumazet@gmail.com,
        mark.langsdorf@calxeda.com
Subject: Re: [PATCH 0/6] Calxeda xgmac performance fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <508EC267.6020208@calxeda.com>
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
	<508EC267.6020208@calxeda.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>
Date: Mon, 29 Oct 2012 12:52:39 -0500

> David,
> 
> On 10/12/2012 10:15 AM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>> 
>> This is a series of performance improvements to the xgmac driver. The most
>> significant changes are the alignment fixes to avoid alignment traps on
>> received frames and using relaxed i/o accessors.
> 
> Can you please apply this series for 3.7. They are all self-contained to
> the xgmac driver and fix some performance issues including unaligned
> access traps in the IP stack. If 3.7 is not acceptable, then 3.8 is fine.
> 
> Note that only patch 5 has a v2 version.

If you look in patchwork, these patches are marked "deferred"
which means that were not appropriate for submission when you
posted them (we were in the merge window and the net-next tree
was closed).

Which means you must repost the series, and I will apply this
to net-next for 3.8

Always check patchwork, it is never necessary to ask me questions like
this, the answers are there.
