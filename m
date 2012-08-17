Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab2HQLpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:45:34 -0400
Received: from antcom.de ([188.40.178.216]:59008 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2HQLpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:45:33 -0400
Message-ID: <502E2EDB.2050200@antcom.de>
Date: Fri, 17 Aug 2012 13:45:31 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: dedekind1@gmail.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform
 data
References: <1345122935-22115-1-git-send-email-stigge@antcom.de> <1345201311.27859.51.camel@sauron.fi.intel.com> <1345201835.27859.52.camel@sauron.fi.intel.com> <201208171140.50388.arnd@arndb.de>
In-Reply-To: <201208171140.50388.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:40 PM, Arnd Bergmann wrote:
>> Actually the mtd patches do not compile-depend on it, sorry, I am
>> dropping it from the MTD tree. Thanks!
> 
> For reference, I'm fine with either outcome, I don't mind seeing an
> occasional collision with subsystem trees, as they tend to be trivial
> to resolve.
> 
> If you split a series to go through multiple git trees, you have to
> ensure that both halves are actually regression free by themselves,

Of course. But in this very case, they are. So I'd prefer pushing them
via different trees because I have other patches for mach-lpc32xx in the
queue and would like to minimize work for you. :-)

Roland
