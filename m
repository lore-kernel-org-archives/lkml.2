Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2JYAsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:48:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56848 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757206Ab2JYAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:48:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/LjTl3lYwCS6JWtYCqqxIj
Date: Wed, 24 Oct 2012 17:48:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, arnd@arndb.de, olof@lixom.net,
        rdunlap@xenotime.net, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121025004806.GK11928@atomide.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016165043.GS15569@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121016 09:53]:
> * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > ocp2scp was not having pdata support which makes *musb* fail for non-dt
> > boot in OMAP platform. The pdata will have information about the devices
> > that is connected to ocp2scp. ocp2scp driver will now make use of this
> > information to create the devices that is attached to ocp2scp.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> This fixes the regression on my panda es for musb port:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Looks like nobody has picked this one up and we need it to
fix the musb regression on omap, so I'll queue these up.

Regards,

Tony
