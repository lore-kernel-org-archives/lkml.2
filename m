Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0LQNej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:34:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33427 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754425Ab0LQNei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:34:38 -0500
Date: Fri, 17 Dec 2010 13:34:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Message-ID: <20101217133434.GH31453@rakim.wolfsonmicro.main>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <20101217125427.GA29640@sirena.org.uk>
 <201012171425.07775.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012171425.07775.rjw@sisk.pl>
X-Cookie: I just had a NOSE JOB!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:25:07PM +0100, Rafael J. Wysocki wrote:
> On Friday, December 17, 2010, Mark Brown wrote:

> > It'd be really good if this could all be factored out into the PM core,
> > we're going to have to do the same thing for at least SPI as well and
> > possibly some other buses :/

> So how exactly the PM core is supposed to include those things?

> There certainly are other buses that don't want to do them.

By, for example, providing default implementations which the buses can
use if they choose to.
