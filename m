Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1JCSVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:21:34 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23020 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1JCSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:21:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+V5QsiJRa2KdIbkh00SZlb
Date: Mon, 3 Oct 2011 11:21:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 24/30] ARM: omap2+: ensure that one of omap2/3/4 is
 selected
Message-ID: <20111003182124.GA6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-25-git-send-email-arnd@arndb.de>
 <4E89462D.7010208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89462D.7010208@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111002 21:46]:
> On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> > Random configurations can fail if none of the omap families
> > in mach-omap2 is selected. This patch automatically selects
> > omap2 if the user has not made any other choice.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> OMAP4 would have been a better default but am fine with
> OMAP2 too.
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Hmm yeah then that would mean constant patching for the
latest omap.. So OMAP2 here makes the fastest build and
avoids having to update it on regular basis.

Acked-by: Tony Lindgren <tony@atomide.com>
