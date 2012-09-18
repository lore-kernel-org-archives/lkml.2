Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2IRSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:25:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28396 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753619Ab2IRSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18gNtV+c6WuzAeme6aNh/1v
Date: Tue, 18 Sep 2012 11:24:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH 3/3] i2c: OMAP fix driver initialization message
Message-ID: <20120918182447.GA11762@atomide.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com>
 <1348070841-23354-4-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348070841-23354-4-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [120918 11:13]:
> The message spit out when the i2c-omap driver load is printing
> the platform device's id as a bus number. However when booting
> from OF id is -1, which is not so nice.
> 
> Fix it by printing the adapter number.
> 
> [    0.210467] omap_i2c 44e0b000.i2c: bus -1 rev2.4.0 at 400 kHz
> 	vs
> [    0.210467] omap_i2c 44e0b000.i2c: bus 0 rev2.4.0 at 400 kHz
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Acked-by: Tony Lindgren <tony@atomide.com>
