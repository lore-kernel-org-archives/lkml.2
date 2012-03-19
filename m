Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2CSVDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:03:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38954 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2CSVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:03:53 -0400
Date: Mon, 19 Mar 2012 17:03:49 -0400 (EDT)
Message-Id: <20120319.170349.957038489849471796.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv4: Standardize prefixes for message
 logging
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332190804.6525.12.camel@joe2Laptop>
References: <20120312.170558.584205292599435892.davem@davemloft.net>
	<1331598952.13200.43.camel@joe2Laptop>
	<1332190804.6525.12.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 14:03:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 19 Mar 2012 14:00:04 -0700

> On Mon, 2012-03-12 at 17:35 -0700, Joe Perches wrote:
>> On Mon, 2012-03-12 at 17:05 -0700, David Miller wrote:
>> > From: Joe Perches <joe@perches.com>
>> > Date: Mon, 12 Mar 2012 10:03:32 -0700
>> > > Add #define pr_fmt(fmt) as appropriate.
>> > > Add "IPv4: ", "TCP: ", and "IPsec: " to appropriate files.
>> > > Standardize on "UDPLite: " for appropriate uses.
>> > > Some prefixes were previously "UDPLITE: " and "UDP-Lite: ".
>> []
>> > Looks good, and applied,
>> OK.  I'll submit a similar change for net/ipv6 in awhile.
> 
> Would you still take a similar IPv6: prefix
> change for net-next or should I wait until
> the next release cycle?

Sure why not, everyone else is being a complete idiot and submitting
all of their shit at the merge window openning.

I am backlogged every single time the merge window opens up, why do
you people wait until the last possible minute to submit things?  Are
you all too selfish or too stupid to care?

Every single one of you know it's coming, you see several -rc releases
go out.

The merge window isn't a trigger to "get it done and submitted right
now."

Instead, it really means "too late."
