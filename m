Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab0COTBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:01:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35857
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965680Ab0COTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:01:20 -0400
Date: Mon, 15 Mar 2010 12:01:42 -0700 (PDT)
Message-Id: <20100315.120142.113006088.davem@davemloft.net>
To: kaber@trash.net
Cc: joe@perches.com, wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
       netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter/ipvs/ip_vs_ftp.c: Remove use of NIPQUAD
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B9E5E43.9060206@trash.net>
References: <1268094699.1617.5.camel@Joe-Laptop.home>
	<4B9E5E43.9060206@trash.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 15 Mar 2010 17:20:19 +0100

> Joe Perches wrote:
>> NIPQUAD has very few uses left.
>> 
>> Remove this use and make the code have the identical form of the only
>> other use of "%u,%u,%u,%u,%u,%u" in net/ipv4/netfilter/nf_nat_ftp.c
> 
> Are we trying to remove NIPQUAD?

Yes.

