Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0HYMw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:52:59 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:53669 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HYMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:52:56 -0400
Date: Wed, 25 Aug 2010 14:54:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100825125451.GH2153@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <201008241726.08797.arnd@arndb.de>
 <20100824154740.GD2160@osiris.boeblingen.de.ibm.com>
 <201008251414.16411.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008251414.16411.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 02:14:16PM +0200, Arnd Bergmann wrote:
> > Then maybe add a "choice" Kconfig option in a way that both allyesconfig
> > as well as allnoconfig will build?
> 
> I think it would be easier to remove the config option entirely on s390
> and just always warn. As I said earlier in this thread, I generally
> don't think this particular warning is more important than a lot of
> the other ones that we don't turn into errors.

I disagree: a default kernel build should compile without the noise of
tens of false positive warnings.
Nobody would look at new warnings and fix possible bugs.
That's why I want to have an option to turn the warnings off (default).

Or are you volunteering to "fix" all the false positives? :)
