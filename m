Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0GEIzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:55:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53472 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0GEIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:55:33 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CLP4lJ1ifJgkvHjjGYWHf
Date: Mon, 5 Jul 2010 11:55:20 +0300
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: ext Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Ladislav Michl <ladis@linux-mips.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vamos@i4.informatik.uni-erlangen.de" 
	<vamos@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 20/33] Removing dead MACH_OMAP2_H4_USB1
Message-ID: <20100705085518.GK15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <24b01f2edebd09e37306c35f14401819d8219549.1277911346.git.siccegge@cs.fau.de>
 <20100701073523.GT3843@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701073523.GT3843@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <felipe.balbi@nokia.com> [100701 10:32]:
> On Wed, Jun 30, 2010 at 06:00:23PM +0200, ext Christoph Egger wrote:
> >MACH_OMAP2_H4_USB1 doesn't exist in Kconfig, therefore removing all
> >references for it from the source code.
> >
> >Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> 
> Does this apply on top of Tony's recent patches ??

Yes, I've applied both this and the previous patch.

Tony
