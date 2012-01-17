Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2AQTAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:00:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56819 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2AQTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:00:29 -0500
Date: Tue, 17 Jan 2012 13:59:21 -0500 (EST)
Message-Id: <20120117.135921.478710025739512182.davem@davemloft.net>
To: joe@perches.com
Cc: mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326826496.17202.13.camel@joe2Laptop>
References: <1326826273.17202.11.camel@joe2Laptop>
	<20120117.135227.1766844710849171296.davem@davemloft.net>
	<1326826496.17202.13.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 10:59:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 17 Jan 2012 10:54:56 -0800

> On Tue, 2012-01-17 at 13:52 -0500, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> no reason
>> to treat this any differently.
> 
> A NULL address is specifically passed here.

And I said fix that skb_gso_whatever case, because it's wrong.
