Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2LNRWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:22:47 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:49716 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756538Ab2LNRWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:22:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188+OlrQPPgjQ9rN49GAupm
Date: Fri, 14 Dec 2012 09:22:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <thomas@tomweber.eu>
Cc: Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP3: Devkit8000: Add DDC i2c_bus_num
Message-ID: <20121214172242.GR4989@atomide.com>
References: <1353003123-7335-1-git-send-email-thomas@tomweber.eu>
 <20121214172111.GQ4989@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214172111.GQ4989@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121214 09:23]:
> * Thomas Weber <thomas@tomweber.eu> [121115 10:14]:
> > Add i2c bus number for DVI output.
> > The driver uses this to detect if a panel is connected and to read EDID.
> 
> Thanks applying into omap-for-v3.8/fixes-for-merge-window.

Oops, dropping and using Tomi's generic version instead.

Tony
