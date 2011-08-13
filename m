Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1HMWuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 18:50:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35827 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1HMWuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 18:50:11 -0400
Date: Sat, 13 Aug 2011 15:49:04 -0700 (PDT)
Message-Id: <20110813.154904.1265860342850690821.davem@davemloft.net>
To: brade@informatik.uni-muenchen.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [SOLVED: r8169 is the culprit] Re: 2.6.39, 3.0.0-rc7+:
 complete system freeze with rsync on big directory
From: David Miller <davem@davemloft.net>
In-Reply-To: <201108140017.31063.brade@informatik.uni-muenchen.de>
References: <20110721112804.7aa0043d.taeuber@bbaw.de>
	<201107212013.14561.brade@informatik.uni-muenchen.de>
	<201108140017.31063.brade@informatik.uni-muenchen.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 13 Aug 2011 15:49:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Brade <brade@informatik.uni-muenchen.de>
Date: Sun, 14 Aug 2011 00:17:30 +0200

> I don't know if you are interested in fixing r8169 but if so and you need 
> anything, let me know how I can help.

The first thing you need to do is send your report to
netdev@vger.kernel.org and the listed r8169 maintainers
(nic_swsd@realtek.com and romieu@fr.zoreil.com), nobody on
linux-kernel will be able to fix this.
