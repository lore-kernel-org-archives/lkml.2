Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0HYOir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 10:38:47 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41470 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0HYOio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 10:38:44 -0400
Date: Wed, 25 Aug 2010 16:40:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100825144040.GI2153@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <201008251414.16411.arnd@arndb.de>
 <20100825125451.GH2153@osiris.boeblingen.de.ibm.com>
 <201008251555.53653.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008251555.53653.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 03:55:53PM +0200, Arnd Bergmann wrote:
> On Wednesday 25 August 2010, Heiko Carstens wrote:
> > > I think it would be easier to remove the config option entirely on s390
> > > and just always warn. As I said earlier in this thread, I generally
> > > don't think this particular warning is more important than a lot of
> > > the other ones that we don't turn into errors.
> > 
> > I disagree: a default kernel build should compile without the noise of
> > tens of false positive warnings.
> > Nobody would look at new warnings and fix possible bugs.
> > That's why I want to have an option to turn the warnings off (default).
> > 
> > Or are you volunteering to "fix" all the false positives? :)
> 
> If you don't want to see the warnings, then just remove the strict checks.
> We already concluded that there is little value in them on s390 since it only
> shows false postives.
> 
> Maybe the easiest way would be to rename the option on s390 and move all
> the other ones into a common place.

Yes, feel free to do that.
