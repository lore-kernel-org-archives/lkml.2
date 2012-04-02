Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2DBJgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:36:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2DBJgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:36:08 -0400
Date: Mon, 02 Apr 2012 05:35:44 -0400 (EDT)
Message-Id: <20120402.053544.1502825597915995582.davem@davemloft.net>
To: martin@lucina.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implement IP_EVIL socket option (RFC 3514)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120402092410.GA7601@dezo.moloch.sk>
References: <1333284791-5363-1-git-send-email-martin@lucina.net>
	<20120401.152048.267766557618433051.davem@davemloft.net>
	<20120402092410.GA7601@dezo.moloch.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 02 Apr 2012 02:36:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Lucina <martin@lucina.net>
Date: Mon, 2 Apr 2012 11:24:10 +0200

> davem@davemloft.net said:
>> 
>> I'm extremely disappointed with the april fools submissions this
>> year to be honest...
> 
> Well, with Anonymous making their own distro, and the advertised "takedown
> of the Internet" on Saturday, it seemed timeley. I guess I should have
> written a more convincing blurb in the commit message...

It wasn't the blurb it was simply that you're at least the third
person to submit a patch like this over the years, here's one:

http://www.version6.net/patches/linux-2.4.20-rfc3514.dif

Someone did a netfilter iptables module too:

http://www.gossamer-threads.com/lists/linux/kernel/431645
