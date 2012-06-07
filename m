Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2FGUw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:52:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36587 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755263Ab2FGUwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:52:54 -0400
Message-ID: <1339102373.14838.18.camel@joe2Laptop>
Subject: Re: [PATCH v10] tilegx network driver: initial support
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        bhutchings@solarflare.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 07 Jun 2012 13:52:53 -0700
In-Reply-To: <201206072031.q57KV0NG029301@farm-0023.internal.tilera.com>
References: <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
	 <1339004459.26966.31.camel@edumazet-glaptop> <4FCFA312.4020505@tilera.com>
	 <20120606.115440.1245419453265419850.davem@davemloft.net>
	 <201206072031.q57KV0NG029301@farm-0023.internal.tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 16:42 -0400, Chris Metcalf wrote:
> This change adds support for the tilegx network driver based on the
> GXIO IORPC support in the tilegx software stack, using the on-chip
> mPIPE packet processing engine.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This version makes the driver multi-queued and support non-zero
> tx_queue_len.  I also made a couple of magic numbers into #defines.
> I skimmed the tg3.c driver, but didn't see any other obvious
> changes that would be appropriate.
> 

Hi Chris.

Can you please use git send-email instead of
generating odd header dates like April 6, 2012
and Sept 16, 2001?

git send-email will use your system date.


