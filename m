Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab2JJTis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:38:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60367 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753977Ab2JJTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:38:47 -0400
Message-ID: <1349897923.2035.31.camel@joe-AO722>
Subject: [RFC net-next] treewide: s/ipv4_is_<foo>()/ipv4_addr_<foo>/
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Brian Haley <brian.haley@hp.com>
Date: Wed, 10 Oct 2012 12:38:43 -0700
In-Reply-To: <1349897005.2035.24.camel@joe-AO722>
References: <1349894559.2035.12.camel@joe-AO722>
	 <1349895710.21172.7235.camel@edumazet-glaptop>
	 <1349897005.2035.24.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipv4 and ipv6 use different styles for these tests.

ipv4_is_<foo>(__be32)
ipv6_addr_<foo>(struct in6_addr *)

Perhaps it'd be good to convert the ipv4 tests to the ipv6 style.

There are ~100 instances of ipv4_is_<foo> tests treewide.


