Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1JCSWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:22:21 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52644 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263Ab1JCSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:22:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+YjwqmUgzM2bXO2toHCBqv
Date: Mon, 3 Oct 2011 11:22:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/30] ARM: OMAP depends on MMU
Message-ID: <20111003182204.GB6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-26-git-send-email-arnd@arndb.de>
 <4E894664.5090609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E894664.5090609@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111002 21:47]:
> On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> > There is no way to build OMAP kernels without an MMU
> > at this point because of dependencies on MMU-only functions.
> > 
> > As long as nobody is interested in fixing this, let's just disable
> > this platforms for nommu kernels.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

This should be fine for now:

Acked-by: Tony Lindgren <tony@atomide.com>
