Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0GOJJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:09:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34971 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932766Ab0GOJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:09:35 -0400
Date: Thu, 15 Jul 2010 10:09:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Sundar R IYER <sundar.iyer@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100715090932.GC23529@rakim.wolfsonmicro.main>
References: <20100714145748.GF31073@rakim.wolfsonmicro.main>
 <20100714153643.GB1689@bnru01.bnr.st.com>
 <20100714154726.GH31073@rakim.wolfsonmicro.main>
 <20100714160941.GC1689@bnru01.bnr.st.com>
 <20100714162048.GA27512@rakim.wolfsonmicro.main>
 <20100714164708.GD1689@bnru01.bnr.st.com>
 <20100714170323.GF5933@sirena.org.uk>
 <20100714173650.GA21893@bnru01.bnr.st.com>
 <20100714184251.GG5933@sirena.org.uk>
 <AANLkTimWjozzhTG491JVLUIICh6YonO4Emp07AG1nMj-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWjozzhTG491JVLUIICh6YonO4Emp07AG1nMj-@mail.gmail.com>
X-Cookie: There's only one everything.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 12:51:50AM +0200, Linus Walleij wrote:

> For U8500 there is a dedicated autonomous system in the silicon, called
> PRCMU (Power Reset Clock Management Unit) that will actually do
> this using I2C because it has its own CPU and can transmit I2C
> messages even when the ARM CPU cores are turned off. So this is
> indeed a first-timer and not strange that it looks unfamiliar ...

This sort of design is becoming more and more common but it's still the
same thing from the point of view of the kernel - something else goes
off and does magic without the kernel explicitly doing anything.
