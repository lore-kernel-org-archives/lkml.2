Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2DCXvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:51:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39689 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2DCXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:51:06 -0400
Date: Tue, 03 Apr 2012 19:48:45 -0400 (EDT)
Message-Id: <20120403.194845.437828259714310359.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: joe@perches.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tilepro ethernet driver: fix a few minor issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F7B8884.7070901@tilera.com>
References: <20120403.184004.2056266545823149252.davem@davemloft.net>
	<1333494088.2695.29.camel@joe2Laptop>
	<4F7B8884.7070901@tilera.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 16:48:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 3 Apr 2012 19:32:20 -0400

> David, I concur that it would be useful to make this canonical somewhere,
> since folks who are not aware of your preferences will obviously follow the
> CodingStyle document until corrected by you, which seems like a pain for
> you.  I suspect a modified version of Joe's original CodingStyle change,
> along with a comparable change in checkpatch, is the most "scalable" solution.

I'll try to find time to address this.
