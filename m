Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab1LLTow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:44:52 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48584 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753501Ab1LLTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:44:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pMfJs/cs7xw3gQGHG8qW8
Date: Mon, 12 Dec 2011 11:44:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Heikki Krogerus <krohei@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] omap: rx51: initialize isp1704 properly
Message-ID: <20111212194445.GG32251@atomide.com>
References: <20111207193141.GG31337@atomide.com>
 <1323287816-2809-1-git-send-email-felipe.contreras@gmail.com>
 <20111208144044.GA25415@xps8300>
 <CAMP44s2noD4TXBALOc0JkcbVroYFnp3BaSozrQYdUbsv50xuoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2noD4TXBALOc0JkcbVroYFnp3BaSozrQYdUbsv50xuoQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [111208 11:52]:
> On Thu, Dec 8, 2011 at 4:40 PM, Heikki Krogerus <krohei@gmail.com> wrote:
> > On Wed, Dec 07, 2011 at 09:56:56PM +0200, Felipe Contreras wrote:
> >> From: Heikki Krogerus <krohei@gmail.com>
> >
> > I would prefer that you change this so this is from you, like it
> > actually is. You can mention me in the commit message if you like.
> 
> Well, you came with the fix, I just typed it down, but as you wish :)
> 
> >> Without this USB networking doesn't work as the link is never detected.
> >
> > What this changes is, it leaves the transceiver powered by default
> > instead of setting it into power off mode. So not only USB networking
> > is affected by this. If isp1704_charger is not enabled with RX51, USB
> > does not work at all. Please change the comment.
> 
> I've updated the patch.

Sorry what's the deal with this one? Is this the one to use or is there
some other patch?

Tony
