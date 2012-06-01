Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab2FAK6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 06:58:09 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:39377 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982Ab2FAK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 06:58:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19gqISF+pmE9I4cYdST7g6f
Date: Fri, 1 Jun 2012 03:58:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, paul@pwsan.com,
        linux@arm.linux.org.uk, b-cousson@ti.com, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
Message-ID: <20120601105759.GJ12766@atomide.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
 <201205301843.51568.arnd@arndb.de>
 <CAAe_U6LFFstds=iQ7cy7gM9vWbfRgf5z0gaRp_-bu0Qjx6eA1Q@mail.gmail.com>
 <201205310922.18550.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205310922.18550.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120531 02:26]:
> On Thursday 31 May 2012, ABRAHAM, KISHON VIJAY wrote:
> > >
> > > Just put the devices you actually want into the device tree instead and
> > > have them automatically created.
> > 
> > But shouldn't device tree support and non-device tree support co-exist
> > till the non-device tree is completely knocked out of the kernel? Even
> 
> Well, it's a new driver, so there is no regression in supporting it only
> on DT-enabled boards. OMAP5 is DT-only anyway and OMAP4 only supports two
> boards that should both be working with the generic DT code already.

I agree, let's keep the new omap4/5 drivers DT only.

Regards,

Tony
