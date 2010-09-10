Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0IJSmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:42:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58980 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750946Ab0IJSmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:42:00 -0400
Date: Fri, 10 Sep 2010 19:41:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: SV: SV: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100910184158.GA12787@rakim.wolfsonmicro.main>
References: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>
 <20100910164352.GG23903@sirena.org.uk>
 <33A307AF30D7BF4F811B1568FE7A9B181C357DCD@EXDCVYMBSTM006.EQ1STM.local>
 <20100910181325.GA11584@rakim.wolfsonmicro.main>
 <33A307AF30D7BF4F811B1568FE7A9B181C357DCE@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B181C357DCE@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: I know how to do SPECIAL EFFECTS!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 08:27:38PM +0200, Mattias WALLIN wrote:

Please fix your mail client to word wrap within paragraphs.

> >Pretty much; probably needs to be slightly more involved than that to
> >make sure the selection lines up with the core but certainly the same
> >effect for users.

> Sorry I don't follow.

If CONFIG_DEBUG_FS=y but the chip core is built as a module your
suggested change would try to build the debugfs code into the kernel
linking against symbols defined in the module.

> But after thinking about it I realize that only changing the Makefile
> is not a good idea 

> I need ifdefs in the .c file for avoiding build problems. Isn't the
> first solution with Kconfig better?

I don't see what relevance of these two points to each other?  You can
check for CONFIG_DEBUG_FS just as easily as for the new Kconfig symbol
you added.  No matter what you do you need ifdefs in the code.
