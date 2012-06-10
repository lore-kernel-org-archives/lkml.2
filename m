Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab2FJEVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 00:21:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32956 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2FJEVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 00:21:51 -0400
Date: Sat, 09 Jun 2012 21:21:47 -0700 (PDT)
Message-Id: <20120609.212147.1738198233131370927.davem@davemloft.net>
To: wfg@linux.intel.com
Cc: netdev@vger.kernel.org, gaofeng@cn.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inet: Initialize per-netns inetpeer roots in
 net/ipv{4,6}/route.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120610031634.GA10032@localhost>
References: <20120610015832.GA9175@localhost>
	<20120609.190451.182034193302304295.davem@davemloft.net>
	<20120610031634.GA10032@localhost>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <wfg@linux.intel.com>
Date: Sun, 10 Jun 2012 11:16:34 +0800

> In long run, such build-fix patches can also be auto tested and
> reported, somehow in this way. You just create a temporary branch

Sorry, no.
