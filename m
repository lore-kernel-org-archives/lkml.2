Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab2BJRkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:40:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15499 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2BJRkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:40:51 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+PuTrm0SiNu/pYr7Y+VI+8
Date: Fri, 10 Feb 2012 09:40:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <matt@ohporter.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap: board-omap3evm: add required smsc911x regulators
Message-ID: <20120210174046.GQ1426@atomide.com>
References: <1328738812-26755-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328738812-26755-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <matt@ohporter.com> [120208 13:35]:
> This fixes smsc911x support on omap3evm that has been broken since
> the smsc911x driver was updated to require the existence of vdd33a
> and vddvario supplies.

Great. Few comments:

1. Could you please include the smsc911x commit and subject here too
   so it clearly shows the regression?

2. Also, why don't you add this fixed regulator to gpmc-smsc911.c?

That way it gets fixed for other too, like zoom2/3.

Regards,

Tony
