Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0IJSN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:13:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46401 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067Ab0IJSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:13:28 -0400
Date: Fri, 10 Sep 2010 19:13:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias WALLIN <mattias.wallin@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: SV: [PATCH 2/3] MFD: AB8500 debugfs
Message-ID: <20100910181325.GA11584@rakim.wolfsonmicro.main>
References: <1284134031-8979-1-git-send-email-mattias.wallin@stericsson.com>
 <20100910164352.GG23903@sirena.org.uk>
 <33A307AF30D7BF4F811B1568FE7A9B181C357DCD@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33A307AF30D7BF4F811B1568FE7A9B181C357DCD@EXDCVYMBSTM006.EQ1STM.local>
X-Cookie: Trap full -- please empty.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 08:11:48PM +0200, Mattias WALLIN wrote:
> 
> > Might it be sensible to just unconditionally enable this if debugfs is
> > enabled?

> Do you mean remove the Kconfig part and instead have a Makefile with:

> +obj-$(CONFIG_DEBUG_FS)     += ab8500-debugfs.o

> If so it is ok with me.

Pretty much; probably needs to be slightly more involved than that to
make sure the selection lines up with the core but certainly the same
effect for users.
