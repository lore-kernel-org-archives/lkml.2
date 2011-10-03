Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1JCS2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:28:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34147 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1JCS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:28:13 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/VMWKRmU5uVSj001Kc82Mj
Date: Mon, 3 Oct 2011 11:28:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/30] ARM: omap2: select ARM_AMBA for OMAP3_EMU
Message-ID: <20111003182810.GF6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-31-git-send-email-arnd@arndb.de>
 <4E8948C5.6080301@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8948C5.6080301@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [111002 21:58]:
> On Sunday 02 October 2011 08:16 PM, Arnd Bergmann wrote:
> > OMAP3_EMU needs OC_ETM, which needs ARM_AMBA. Since the latter
> > dependency is getting turned from a 'select' into a 'depends',
> > omap has to select ARM_AMBA itself in order to have a correct
> > dependency chain. Alternatively, we could change OMAP3_EMU
> > to have a 'depends on OC_ETM' instead of selecting it.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>
