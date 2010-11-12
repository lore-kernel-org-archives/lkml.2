Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0KLRfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:35:46 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51909 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0KLRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:35:43 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+O4goYbBaInFWiZI+tLg5
Date: Fri, 12 Nov 2010 09:35:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: Re: [PATCHv5] OMAP: Serial: Define OMAP uart MDR1 reg and remove
 magic numbers
Message-ID: <20101112173531.GD9264@atomide.com>
References: <1289568557-9727-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289568557-9727-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com> [101112 05:22]:
> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> 
> Define MDR1 register serial definitions used in serial and
> bluetooth drivers.
> Change magic number to ones defined in serial_reg for omap1/2
> serial driver.
> Remove redefined MDR1 register definitions in omap-serial driver.

Thanks, queueing this for 2.6.38 and adding the ack from Greg from
the previous version.

Tony
