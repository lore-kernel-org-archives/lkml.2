Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2KWT2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:28:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49544 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2KWT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:28:21 -0500
Date: Fri, 23 Nov 2012 14:28:17 -0500 (EST)
Message-Id: <20121123.142817.1791723278472502940.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121122165620.GA9714@paolo-ThinkPad-W520>
References: <20121122165620.GA9714@paolo-ThinkPad-W520>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Thu, 22 Nov 2012 17:56:20 +0100

> +/*
> +
> + */

Please don't add useless things like this in your patch.

Thank you.
