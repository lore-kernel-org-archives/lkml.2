Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1FNLsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:48:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60414 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755894Ab1FNLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:48:51 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Thc4ewW5XWJ7oRZu096db
Date: Tue, 14 Jun 2011 04:48:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs
 entries
Message-ID: <20110614114848.GS3352@atomide.com>
References: <201106070316.41099.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106070316.41099.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [110606 18:15]:
> 
> Removing __initdata tags, introduced by commit 
> bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a bunch of 
> section mismatches", from corresponding platform_device structures 
> declared in arch/arm/mach-omap1/board-ams-delta.c, corrects the problem 
> for me, which may indicate that their members (.name ?) are still 
> referred to during runtime so they shouldn't be freed after boot.

Sounds like this needs a bit more research where this initdata
gets used?

Tony
