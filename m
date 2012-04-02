Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab2DBJmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:42:52 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:50362 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2DBJmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:42:51 -0400
Date: Mon, 2 Apr 2012 11:42:49 +0200
From: Martin Lucina <martin@lucina.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implement IP_EVIL socket option (RFC 3514)
Message-ID: <20120402094249.GB7601@dezo.moloch.sk>
References: <1333284791-5363-1-git-send-email-martin@lucina.net>
 <20120401.152048.267766557618433051.davem@davemloft.net>
 <20120402092410.GA7601@dezo.moloch.sk>
 <20120402.053544.1502825597915995582.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402.053544.1502825597915995582.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

davem@davemloft.net said:
> It wasn't the blurb it was simply that you're at least the third
> person to submit a patch like this over the years, here's one:
> 
> http://www.version6.net/patches/linux-2.4.20-rfc3514.dif
> 
> Someone did a netfilter iptables module too:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/431645

I missed the former patch completely, sorry about that. Googling for "evil
bit implementation" did turn up the ipt_evil patch but no corresponding
patch to actually let an application *set* the bit.

-- 
Martin Lucina
http://lucina.net/ (interwebs/blogs/rants/consulting)
martin@lucina.net  (smtp/xmpp/jabber/gtalk)
@matolucina        (twitter)
