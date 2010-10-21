Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab0JUP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:57:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56204 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0JUP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:57:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/5dmms3QtebV0ypzItFO6b
Date: Thu, 21 Oct 2010 08:57:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Roger Quadros <roger.quadros@nokia.com>,
        ext Felipe Contreras <felipe.contreras@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101021155710.GB3616@atomide.com>
References: <4CBD9FD5.506@nokia.com>
 <AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
 <4CBE9E69.6060803@nokia.com>
 <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
 <4CBEB312.7060400@nokia.com>
 <AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
 <4CBEE186.8090701@nokia.com>
 <AANLkTinULxyUg_vHjk9RsQm4Row7vRC9ApzYXt7ZMQJD@mail.gmail.com>
 <4CC0493F.1000701@nokia.com>
 <20101021154125.GR3958@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021154125.GR3958@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [101021 08:32]:
> Hi,
> 
> On Thu, Oct 21, 2010 at 09:07:59AM -0500, Roger Quadros wrote:
> >But I'm not sure that omap_udc is used only for OMAP1 architecture.
> >Dave/Tony should confirm this.
> 
> Maybe the old omap2420_h4 board still uses it, but from 2430 I think the
> ip isn't even there anymore.

I don't think it's currently working on 2420. But still, the drivers
should be platform independent. All the drivers that might be possible
should at least build and not mess up things for other platforms.

Regards,

Tony
