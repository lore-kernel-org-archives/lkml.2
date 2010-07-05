Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0GEIZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:25:01 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58139 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab0GEIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:24:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OGaSYk7Z5r5DjMv70iSXu
Date: Mon, 5 Jul 2010 11:24:46 +0300
From: Tony Lindgren <tony@atomide.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       Cory Maccarrone <darkstar6262@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 12/33] Removing dead OMAP_STI
Message-ID: <20100705082444.GF15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <35d3c6a25b5cc05a5eee3037075ccede85b1917f.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d3c6a25b5cc05a5eee3037075ccede85b1917f.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Egger <siccegge@cs.fau.de> [100630 18:51]:
> OMAP_STI doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

Thanks, applied.

Tony
