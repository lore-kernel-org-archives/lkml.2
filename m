Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376Ab0COQU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:20:27 -0400
Received: from stinky.trash.net ([213.144.137.162]:46566 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965346Ab0COQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:20:23 -0400
Message-ID: <4B9E5E43.9060206@trash.net>
Date: Mon, 15 Mar 2010 17:20:19 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
       Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org, lvs-devel <lvs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/netfilter/ipvs/ip_vs_ftp.c: Remove use of NIPQUAD
References: <1268094699.1617.5.camel@Joe-Laptop.home>
In-Reply-To: <1268094699.1617.5.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> NIPQUAD has very few uses left.
> 
> Remove this use and make the code have the identical form of the only
> other use of "%u,%u,%u,%u,%u,%u" in net/ipv4/netfilter/nf_nat_ftp.c

Are we trying to remove NIPQUAD? In my opinion the current code is
preferrable to open-coding NIPQUAD.
