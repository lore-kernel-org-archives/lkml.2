Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2A1BnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 20:43:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47524 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2A1BnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 20:43:20 -0500
Date: Fri, 27 Jan 2012 20:42:10 -0500 (EST)
Message-Id: <20120127.204210.1693783796267469687.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120127201023.GC2510@tuxdriver.com>
References: <20120127201023.GC2510@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Jan 2012 17:42:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 27 Jan 2012 15:10:23 -0500

> Here are a couple of "one-liner" fixes intended for 3.3.
> 
> A mac80211 fix from Eliad Peller fixes a regression from an earlier
> patche that accidentally removed a necessary line of code.  The other
> one from Eliad adds an overlooked assignment necessary for proper
> management of some state information.  Finally, the fix from Johannes
> moves an unlock to include an additional operation within the critical
> section.
> 
> Pleae let me know if there are problems!

Pulled, thanks John.
