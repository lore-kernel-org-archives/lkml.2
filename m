Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab2HXUCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:02:44 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:38036 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab2HXUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:02:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CCorbP7qivlCqUyaqaHwa
Date: Fri, 24 Aug 2012 13:02:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Balaji T K <balajitk@ti.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rob.herring@calxeda.com, linux-mmc@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] arm/dts: omap5: Add mmc controller nodes and board data
Message-ID: <20120824200221.GW11011@atomide.com>
References: <1344323901-20342-1-git-send-email-balajitk@ti.com>
 <201208070830.01776.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208070830.01776.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120807 02:21]:
> On Tuesday 07 August 2012, Balaji T K wrote:
> > 
> > Add OMAP MMC related device tree data for OMAP5.
> > 
> > Signed-off-by: Balaji T K <balajitk@ti.com>
> > ---
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applying this into omap devel-dt branch. 

Tony
