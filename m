Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab1EZMYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:24:19 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18182 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757485Ab1EZMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:24:18 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rgNXGdbjkK73Kvvwd2JAF
Date: Thu, 26 May 2011 05:24:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap updates for 2.6.40
Message-ID: <20110526122412.GB11352@atomide.com>
References: <20110526113905.GG27250@atomide.com>
 <4DDE441C.2080808@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE441C.2080808@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Igor Grinberg <grinberg@compulab.co.il> [110526 05:10]:
> 
> What about this one: [PATCH v2] arm: omap2plus: move NAND_BLOCK_SIZE out of boards
> 
> Why not include it? It is no new code, just generalize stuff and 11 lines off... not much but still.

Sorry I must have missed it.. Let's see if we can queue it
during the merge window as it's a trivial patch removing
duplicate defines.

Regards,

Tony
