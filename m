Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2JKA4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:56:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36705 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757440Ab2JKA4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:56:20 -0400
Message-ID: <1349916979.2243.13.camel@joe-AO722>
Subject: [RFC net-next] treewide: s/is_<foo>_ether_addr/eth_addr_<foo>
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Brian Haley <brian.haley@hp.com>
Date: Wed, 10 Oct 2012 17:56:19 -0700
In-Reply-To: <1349897923.2035.31.camel@joe-AO722>
References: <1349894559.2035.12.camel@joe-AO722>
	 <1349895710.21172.7235.camel@edumazet-glaptop>
	 <1349897005.2035.24.camel@joe-AO722> <1349897923.2035.31.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe all the is_<foo>_ether_addr  functions should be renamed
to eth_addr_<foo> for more api/style symmetry.

$ git grep --name-only -E "\bis_\w+_ether_addr" | \
  xargs sed -r -i -e 's/\bis_(\w+)_ether_addr\b/eth_addr_\1/g'
$ git diff --shortstat
 304 files changed, 690 insertions(+), 690 deletions(-)

Maybe add #defines of the old names for a few releases.

