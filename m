Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2H3QY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:24:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37429 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2H3QY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:24:57 -0400
Date: Thu, 30 Aug 2012 12:24:53 -0400 (EDT)
Message-Id: <20120830.122453.1449291050128191766.davem@davemloft.net>
To: konrad.wilk@oracle.com
Cc: Ian.Campbell@citrix.com, mgorman@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad@darnok.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] netvm: check for page == NULL when propogating the
 skb->pfmemalloc flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120823141740.GA30305@phenom.dumpdata.com>
References: <20120808.155046.820543563969484712.davem@davemloft.net>
	<1345631207.6821.140.camel@zakaz.uk.xensource.com>
	<20120823141740.GA30305@phenom.dumpdata.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 23 Aug 2012 10:17:40 -0400

> On Wed, Aug 22, 2012 at 11:26:47AM +0100, Ian Campbell wrote:
>> On Wed, 2012-08-08 at 23:50 +0100, David Miller wrote:
>> > Just use something like a call to __pskb_pull_tail(skb, len) and all
>> > that other crap around that area can simply be deleted.
>> 
>> I think you mean something like this, which works for me, although I've
>> only lightly tested it.
>> 
> 
> I've tested it heavily and works great.
> 
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> and I took a look at it too and:
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Applied, thanks everyone.
