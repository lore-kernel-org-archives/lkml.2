Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab0KLRqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:46:10 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64415 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KLRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:46:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19eAWagoullL3qh9qr/WS+v
Date: Fri, 12 Nov 2010 09:45:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "kmpark@infradead.org" <kmpark@infradead.org>,
        "konkers@android.com" <konkers@android.com>,
        "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        "avorontsov@mvista.com" <avorontsov@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srinidhikasagar@gmail.com" <srinidhikasagar@gmail.com>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
Message-ID: <20101112174517.GE9264@atomide.com>
References: <20101112082059.27221.52879.sendpatchset@t400s>
 <20101112082211.27221.47096.sendpatchset@t400s>
 <EAF47CD23C76F840A9E7FCE10091EFAB030D58AE84@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB030D58AE84@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shilimkar, Santosh <santosh.shilimkar@ti.com> [101112 00:16]:
> > -----Original Message-----
> > From: Magnus Damm [mailto:magnus.damm@gmail.com]
> > Sent: Friday, November 12, 2010 1:52 PM
> > To: linux@arm.linux.org.uk
> > Cc: kgene.kim@samsung.com; kmpark@infradead.org; konkers@android.com;
> > tony@atomide.com; adharmap@codeaurora.org; avorontsov@mvista.com; linux-
> > kernel@vger.kernel.org; srinidhikasagar@gmail.com; dwalker@codeaurora.org;
> > Shilimkar, Santosh; ccross@android.com; olof@lixom.net; Magnus Damm;
> > linux-arm-kernel@lists.infradead.org
> > Subject: [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
> > 
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Common GIC entry macro for omap
> > 
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Magnus Damm <damm@opensource.se>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Looks like the From: field got trashed on this one assuming you're
using the patch I posted earlier :)

Tony
