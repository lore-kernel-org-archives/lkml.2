Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2FABxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:53:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2FABxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120531180204.GA28779@mail.gnudd.com>
References: <cover.1338398567.git.rubini@gnudd.com>
	<349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
	<CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
	<4FC72DDF.7080209@codethink.co.uk>
	<CACRpkdZpjn0RBGY+CqqSW3ip0MSQUJSaqN0GD=a4THnPHNM-jg@mail.gmail.com>
	<20120531180204.GA28779@mail.gnudd.com>
Date: Fri, 1 Jun 2012 09:53:15 +0800
Message-ID: <CACRpkdZXnuQe5NXyQBEZJD71Rs=+wvmXkw-4oT53FdU7KE7m2g@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: ben.dooks@codethink.co.uk, lee.jones@linaro.org, giancarlo.asnaghi@st.com,
        linux@arm.linux.org.uk, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 2:02 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> So I'll resubmit in the right way (-M, include/linux/platform_data)
> as soon as I have information for ftd fixup.

OK if nothing happens you can probably just go in and patch:
arch/arm/boot/dts/db8500.dtsi

I suspect it's just the compatible= that needs to be changed to
"arm,primecell" or just have that string added to the others that
are already there for each i2c device entry.

Yours,
Linus Walleij
