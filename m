Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1K3Rgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:36:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53555 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1K3Rgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:36:40 -0500
Date: Wed, 30 Nov 2011 12:36:26 -0500 (EST)
Message-Id: <20111130.123626.308237192773284976.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] net/hyperv: Fix long lines in netvsc.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322666348-6554-1-git-send-email-haiyangz@microsoft.com>
References: <1322666348-6554-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 Nov 2011 09:36:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Well, since Greg's tree is where the staging move happened, he'll have
to take any patches to this driver that happen now, rather than me.
