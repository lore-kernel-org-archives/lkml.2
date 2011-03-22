Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1CVJV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:21:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41845 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1CVJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:21:26 -0400
Date: Tue, 22 Mar 2011 09:21:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
Message-ID: <20110322092113.GB17264@n2100.arm.linux.org.uk>
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103220934.50435.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:34:50AM +0100, Arnd Bergmann wrote:
> On Tuesday 22 March 2011, Stephen Boyd wrote:
> > Commit d232b12 (asm-generic headers: add sizes.h, 2011-01-15)
> > introduced a generic sizes.h. Use that instead of the ARM specific
> > version.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de

I assume the generic version was derived from the ARM version.  Is there
a reason why ARM Ltd's copyright was seemingly dropped?
