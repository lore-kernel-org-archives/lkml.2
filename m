Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2DMRgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:36:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51004 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2DMRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:36:06 -0400
Date: Fri, 13 Apr 2012 13:35:33 -0400 (EDT)
Message-Id: <20120413.133533.212991624580049561.davem@davemloft.net>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, alan@linux.intel.com, andrea@persephoneslair.org
Subject: Re: [PATCH 1/3] NET: pc300, move to staging as it is broken
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
References: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 10:35:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Wed, 11 Apr 2012 11:14:57 +0200

> It was marked as BROKEN back in 2008. It is because the tty handling
> in the driver is really broken.
> 
> There was some activity in January 2012 to fix the driver, but the
> patch was commented to be bogus:
>   https://lkml.org/lkml/2012/1/29/160
> and we have not heard back from the author since then:
>   https://lkml.org/lkml/2012/3/28/412
> 
> So since nobody stepped in and rewrote the driver, it is time to move
> it out of line now. And drop it some time later if nobody comes up
> with patches to fix the driver in staging.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

No objections, I'll let the staging guy handle this :-)

Acked-by: David S. Miller <davem@davemloft.net>
