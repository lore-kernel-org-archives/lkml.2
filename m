Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2AVTgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:36:07 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2AVTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:36:04 -0500
Date: Sun, 22 Jan 2012 14:35:56 -0500 (EST)
Message-Id: <20120122.143556.1031473969223729555.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 1/3] net: fix socket memcg build with !CONFIG_NET
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F1AC8F6.1060703@parallels.com>
References: <1327071436-20763-2-git-send-email-glommer@parallels.com>
	<20120120.141446.136970067758991080.davem@davemloft.net>
	<4F1AC8F6.1060703@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Jan 2012 11:35:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Sat, 21 Jan 2012 18:17:26 +0400

> I am not removing the static branch. This is just a macro, that
> expands to the static branch when the options are in place, and to 0
> if they are not.
> 
> if (0) { } is certainly be removed to the compiler, so the code is out
> anyway.

That's rather non-intuitive, oh well.

I'll apply this, but all of this stuff is an ifdef mess.
