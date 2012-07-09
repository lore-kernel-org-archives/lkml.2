Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2GIHAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:00:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53415 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2GIHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:00:24 -0400
Date: Mon, 09 Jul 2012 00:00:23 -0700 (PDT)
Message-Id: <20120709.000023.862144144755024401.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341370308-23233-1-git-send-email-cjren@qca.qualcomm.com>
References: <1341370308-23233-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <cjren@qca.qualcomm.com>
Date: Wed, 4 Jul 2012 10:51:48 +0800

> some people report atl1c could cause system hang with following
> kernel trace info:
> ---------------------------------------
> WARNING: at.../net/sched/sch_generic.c:258 dev_watchdog+0x1db/0x1d0()
> ...
> NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> ...
> ---------------------------------------
> This is caused by netif_stop_queue calling when cable Link is down.
> So remove netif_stop_queue, because link_watch will take it over.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>

Applied, thanks.
