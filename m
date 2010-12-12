Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0LLWh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:37:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34205
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab0LLWh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:37:57 -0500
Date: Sun, 12 Dec 2010 14:38:25 -0800 (PST)
Message-Id: <20101212.143825.48496658.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET] net-dev: don't use flush_scheduled_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292169185-10579-1-git-send-email-tj@kernel.org>
References: <1292169185-10579-1-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sun, 12 Dec 2010 16:52:56 +0100

> This patchset removes the use of flush_scheduled_work(), which is
> being deprecated, from various network drivers.  It contains the
> following nine patches.
> 
>  0001-drivers-net-remove-unnecessary-flush_scheduled_work-.patch
>  0002-drivers-net-don-t-use-flush_scheduled_work.patch
>  0003-ehea-kill-unused-ehea_rereg_mr_task.patch
>  0004-ehea-don-t-use-flush_scheduled_work.patch
>  0005-iseries_veth-don-t-use-flush_scheduled_work.patch
>  0006-igb-v-ixgbe-don-t-use-flush_scheduled_work.patch
>  0007-sungem-update-gp-reset_task-flushing.patch
>  0008-i2400m-drop-i2400m_schedule_work.patch
>  0009-hostap-don-t-use-flush_scheduled_work.patch
> 
> 0001 and 0002 are straight forward conversions across multiple network
> drivers.  The rest are a bit more involved per-driver or driver family
> conversions.
> 
> This patchset is on top of the current net-next-2.6.git#master
> (ad1184c6cf067a13e8cb2a4e7ccc407f947027d0) and available in the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git net-dev-kill-flush_scheduled_work
> 
> diffstat follows.  Thanks.

I spent the afternoon going over these and they look good to me.
Pulled, thanks a lot.

If any follow-up bug fixes show up just send me relative patches,
thanks again!
