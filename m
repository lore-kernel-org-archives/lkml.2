Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2JJO7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:59:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:34321 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab2JJO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:58:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344211200"; 
   d="scan'208";a="15078552"
Date: Wed, 10 Oct 2012 15:58:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bryan.wu@canonical.com" <bryan.wu@canonical.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "dave.martin@linaro.org" <dave.martin@linaro.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "jonathan.austin@arm.com" <jonathan.austin@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "leif.lindholm@arm.com" <leif.lindholm@arm.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "mmarek@suse.cz" <mmarek@suse.cz>, "rjw@sisk.pl" <rjw@sisk.pl>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL 0/9] ARM architecture fixes for 3.7
In-Reply-To: <201210091840.25176.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1210101557540.2689@kaball.uk.xensource.com>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <20121009160814.GH4625@n2100.arm.linux.org.uk> <201210091840.25176.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Arnd Bergmann wrote:
> On Tuesday 09 October 2012, Russell King - ARM Linux wrote:
> > 
> > On Tue, Oct 09, 2012 at 05:22:54PM +0200, Arnd Bergmann wrote:
> > > Here are some patches that belong into your domain, I hope you can
> > > just send the lot to Linus the next time you send other patches.
> > > 
> > > These bug fixes all address problems found with automated build testing.
> > > Some of them have been around for a long time, other bugs are
> > > regressions since the merge window.
> > 
> > Apart from the sliced off comment in one commit (which XEN people need
> > to confirm they're happy with the final version), I think these are
> > otherwise fine... I'll hold off pulling them until that can be fixed.
> 
> Fixed that now, and I also added the Acks that I got in the meantime,
> changed the dependency from Xen on (CPU_v7 && !CPU_V6), and edited the
> description for patch 6 as Dave suggested.

Thanks for the update, the new Xen patch is fine by me
