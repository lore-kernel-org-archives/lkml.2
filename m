Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab1JCS1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:27:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32098 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab1JCS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:27:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18G0EX1Vtaws/7zXEpZKszk
Date: Mon, 3 Oct 2011 11:27:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/30] ARM: omap: select L2X0 cache on omap4
Message-ID: <20111003182705.GD6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-28-git-send-email-arnd@arndb.de>
 <4E89481C.4070405@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89481C.4070405@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111002 21:55]:
> On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> > The cache controller needs to be enabled for the
> > cortex-a9 specific errata that are also selected
> > to work.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>	

Acked-by: Tony Lindgren <tony@atomide.com>
