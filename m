Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2ISU0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:26:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57320 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2ISU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:26:23 -0400
Date: Wed, 19 Sep 2012 16:26:22 -0400 (EDT)
Message-Id: <20120919.162622.1418427955928784832.davem@davemloft.net>
To: stid.smth@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] fix ZOMBIE state bug in PPPOE driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANEcBPQnsV26UkyGxms0vKM9wK1NxfKjN4Z0qGipQtV4UPZgGA@mail.gmail.com>
References: <CANEcBPSEamgOiGqNUSwB+hYCo1k2OTXDA=qsrw0Co8_F7treWw@mail.gmail.com>
	<CANEcBPQnsV26UkyGxms0vKM9wK1NxfKjN4Z0qGipQtV4UPZgGA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaodong Xu <stid.smth@gmail.com>
Date: Sun, 16 Sep 2012 10:30:53 +0800

> Hi All,
> 
> I found a bug in kernel PPPOE driver.
> When PPPOE is running over a virtual ethernet interface (e.g., a
> bonding interface) and the user tries to delete the interface in case
> the PPPOE state is ZOMBIE, the kernel will loop infinitely while
> unregistering net_device for the reference count is not reset to zero
> which should be done by dev_put().
> 
> The following patch could fix this issue:
> 
> $ git diff

Please read Documentation/SubmittingPatches in the kernel source tree
to learn how to properly submit a patch.

In particular your patch was missing a proper signoff and your Subject
line is incorrectly specified.

Thanks.
