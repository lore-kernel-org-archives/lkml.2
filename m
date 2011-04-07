Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1DGK7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:59:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41318 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1DGK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:59:10 -0400
Date: Thu, 7 Apr 2011 12:58:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: oskar.andero@sonyericsson.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, eric.y.miao@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Victor Boivie <victor.boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110407105850.GJ13963@pengutronix.de>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
 <1302172525.24493.7.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302172525.24493.7.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 12:35:01PM +0200, Paul Bolle wrote:
> On Thu, 2011-04-07 at 10:17 +0200, oskar.andero@sonyericsson.com wrote:
> > +config CMDLINE_EXTEND
> > +	bool "Extend bootloader kernel arguments"
> > +	depends on CMDLINE != ""
> > +	help
> > +	  The default kernel command string will be concatenated with the
> > +	  arguments provided by the boot loader.
> 
> This suggests the parameters provided by the boot loader will override
> corresponding parameters of the default kernel command string. Is that
> correct (for all possible parameters)?
> 
> Either way, shouldn't it be documented, perhaps in this help text, what
> will happen if a parameter of the default kernel command string and a
> parameter provided by the boot loader somehow conflict?
Then you will end up with both parameters I guess. What happens depends
on the parameter in question I guess. IMHO the description is fine.
But I wonder if the new mechanism is useful in the end.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
