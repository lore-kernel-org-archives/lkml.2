Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2JKI2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:28:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49895 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234Ab2JKI2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:28:36 -0400
Message-ID: <1349944115.2243.18.camel@joe-AO722>
Subject: Re: [RFC net-next] treewide: s/ipv4_is_<foo>()/ipv4_addr_<foo>/
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Brian Haley <brian.haley@hp.com>
Date: Thu, 11 Oct 2012 01:28:35 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7037@saturn3.aculab.com>
References: <1349894559.2035.12.camel@joe-AO722>
	 <1349895710.21172.7235.camel@edumazet-glaptop>
	 <1349897005.2035.24.camel@joe-AO722> <1349897923.2035.31.camel@joe-AO722>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7037@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 09:11 +0100, David Laight wrote:
> > ipv4 and ipv6 use different styles for these tests.
> > 
> > ipv4_is_<foo>(__be32)
> > ipv6_addr_<foo>(struct in6_addr *)
> 
> I presume there is a 'const' in there ...
> 
> > Perhaps it'd be good to convert the ipv4 tests to the ipv6 style.
> 
> You don't want to force an IPv4 address (which might be in a register)
> be written out to stack.
> Taking the address also has implications for the optimiser.

Of course not, I'm just talking about renaming.


