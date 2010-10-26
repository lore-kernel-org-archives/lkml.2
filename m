Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab0JZL1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:27:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13998 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab0JZL1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:27:17 -0400
Date: Tue, 26 Oct 2010 13:26:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Ralf Baechle" <ralf@linux-mips.org>, <linux-i2c@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Ben Dooks " <ben-linux@fluff.org>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Wang Qi" <qi.wang@intel.com>, "Wang Yong Y" <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        <andrew.chih.howe.khor@intel.com>
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
Message-ID: <20101026132649.623461f9@endymion.delvare>
In-Reply-To: <001c01cb74f2$d3dd8990$66f8800a@maildom.okisemi.com>
References: <4CC645A1.5010509@dsn.okisemi.com>
	<20101026102048.316d0c04@endymion.delvare>
	<001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com>
	<20101026111322.738b0b14@endymion.delvare>
	<001c01cb74f2$d3dd8990$66f8800a@maildom.okisemi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 18:47:37 +0900, Tomoya MORINAGA wrote:
> Hi Jean,
> 
> On Tuesday, October 26, 2010 6:13 PM, Jean Delvare wrote:
> > The _pch becomes redundant then, i2c-topcliff.c would be enough, but
> > both are fine with me, as my initial concern is gone.
> I agree.
> I will modify to "i2c-topcliff.c".
> 
> > There's no Reviewed-by, Acked-by or Signed-off-by from anyone at Intel
> > in the patch you posted. 
> Must we get Intel's signature ? 
> We have already got the following. Isn't  this enough ?
> > Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> 
> Though I haven't heard like the requirement,
> if Intel's signature is mandatory, I will request to Intel.

It's not mandatory, but the time Ben and myself have to review new
drivers is scarce, so it's in your own interest to have the code
reviewed by people with more time and more interest in the specific
hardware. I can only imagine that Intel wants Topcliff to be supported
as soon as possible by the Linux kernel, so they should certainly have
resources to allocate for the review and testing.

-- 
Jean Delvare
