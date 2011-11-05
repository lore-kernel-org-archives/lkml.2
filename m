Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1KEC1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 22:27:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1KEC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 22:27:53 -0400
Date: Fri, 04 Nov 2011 22:27:35 -0400 (EDT)
Message-Id: <20111104.222735.962844978112109030.davem@davemloft.net>
To: david.decotigny@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, joe@perches.com,
        szymon@janc.net.pl
Subject: Re: [PATCH net v3 0/9] forcedeth: minor fixes for stats, rmmod,
 sparse
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1320457247.git.david.decotigny@google.com>
References: <cover.1320457247.git.david.decotigny@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 04 Nov 2011 19:27:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <david.decotigny@google.com>
Date: Fri,  4 Nov 2011 18:53:24 -0700

> Changes since v2:
>  - removed "Fix a race during rmmod of forcedeth" from the series
>    (will look at it separately with original author)
>  - added "remove unneeded stats updates" and "64-bit stats"
>  - reordered patches
> 
> Changes since v1:
>  - rebased on top of netdev tip
>  - do not repeat name of device in netdev_dbg
>  - do not completely mute TX timeout messages when debug_tx_timeout is
>    not set
>  - make debug_tx_timeout writable in /sys/module
>  Note: I am re-submitting "expose module parameters in /sys/module" as
>        it can be useful in production and I was assured it doesn't add
>        much memory overhead by the sysfs maintainers.

If you want me to apply any of this now you're going to have to split
out the pure bug fixes from the feature additions and submit the feature
bits later when net-next opens back up.

Because things like 64-bit stats and new stat counters are not
appropriate at this time in the development cycle.
