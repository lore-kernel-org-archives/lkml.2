Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2IRUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:25:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46825 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2IRUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:25:55 -0400
Date: Tue, 18 Sep 2012 16:25:53 -0400 (EDT)
Message-Id: <20120918.162553.2196748185499351536.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: jiri@resnulli.us, netdev@vger.kernel.org, mlindner@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net] sky2: fix rx filter setup on link up
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120917141507.7528b3ee@nehalam.linuxnetplumber.net>
References: <20120917091214.5cd9b0f5@nehalam.linuxnetplumber.net>
	<20120917204724.GA1749@minipsycho.orion>
	<20120917141507.7528b3ee@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Mon, 17 Sep 2012 14:15:07 -0700

> Are you sure it isn't IPv6 or something else setting additional mulitcast
> addresses. You may need to instrument the set_multicast call.

I'm confident in Jiri's analysis and patch and it's clear the hardware
is doing this on it's own, so please take his bug fix seriously.
