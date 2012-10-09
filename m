Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2JIQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:08:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49173 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2JIQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:08:27 -0400
Date: Tue, 9 Oct 2012 17:08:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bryan.wu@canonical.com, catalin.marinas@arm.com,
        dave.martin@linaro.org, jeremy@goop.org, jonathan.austin@arm.com,
        konrad.wilk@oracle.com, leif.lindholm@arm.com,
        linus.walleij@linaro.org, damm@opensource.se, mmarek@suse.cz,
        rjw@sisk.pl, stefano.stabellini@eu.citrix.com, sboyd@codeaurora.org,
        tglx@linutronix.de, will.deacon@arm.com, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL 0/9] ARM architecture fixes for 3.7
Message-ID: <20121009160814.GH4625@n2100.arm.linux.org.uk>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:22:54PM +0200, Arnd Bergmann wrote:
> Here are some patches that belong into your domain, I hope you can
> just send the lot to Linus the next time you send other patches.
> 
> These bug fixes all address problems found with automated build testing.
> Some of them have been around for a long time, other bugs are
> regressions since the merge window.

Apart from the sliced off comment in one commit (which XEN people need
to confirm they're happy with the final version), I think these are
otherwise fine... I'll hold off pulling them until that can be fixed.

Thanks.
