Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2AQSqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:46:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56658 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2AQSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:46:48 -0500
Date: Tue, 17 Jan 2012 13:46:40 -0500 (EST)
Message-Id: <20120117.134640.1673981737109339596.davem@davemloft.net>
To: joe@perches.com
Cc: mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326825433.17202.6.camel@joe2Laptop>
References: <1326825433.17202.6.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 10:46:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 17 Jan 2012 10:37:13 -0800

> Passing NULL to %pNF is done in skb_gso_segment
> which could be dereferenced.

skb_gso_segment() should be fixed instead.
