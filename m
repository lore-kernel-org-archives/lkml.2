Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KTSiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:38:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55415 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582Ab2KTSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:38:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 67.169.73.11
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/36kxUdO1PFkTYgGjbOyAX
Date: Tue, 20 Nov 2012 10:38:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [RESEND PATCH v3 2/4] mfd: introduce retu-mfd driver
Message-ID: <20121120183815.GL18567@atomide.com>
References: <1352747326-2195-1-git-send-email-aaro.koskinen@iki.fi>
 <1352747326-2195-3-git-send-email-aaro.koskinen@iki.fi>
 <20121120183427.GK18567@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120183427.GK18567@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121120 10:36]:
> * Aaro Koskinen <aaro.koskinen@iki.fi> [121112 11:11]:
> > Retu is a multi-function device found on Nokia Internet Tablets
> > implementing at least watchdog, RTC, headset detection and power button
> > functionality.
> > 
> > This patch implements minimum functionality providing register access,
> > IRQ handling and power off functions.
> 
> Samuel, you can pick this one up separately now that Wolfram has taken
> the i2c-cbus driver.
> 
> Also, just noticed that this probably should depend on I2C_CBUS as this
> chip will not communicate over other I2C adapters?

Sorry meant to reply to "[PATCH v4 2/4] mfd: introduce retu-mfd driver"
instead of this v3 thread.

Regards,

Tony
