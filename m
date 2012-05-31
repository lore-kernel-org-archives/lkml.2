Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2EaBzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:55:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38078 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2EaBzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1338398567.git.rubini@gnudd.com>
References: <cover.1338398567.git.rubini@gnudd.com>
Date: Thu, 31 May 2012 09:55:33 +0800
Message-ID: <CACRpkdZqD0_5oRwBg2J7ZyCK9=ynGOZnSWrQmtCyph9C3W3jDA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] i2c-nomadik changes
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 1:45 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> In the STA2X11 I/O hub we are exporting a number of AMBA peripherals
> to the PCI world. Using a generic pci-amba driver there is no further
> code for each device, provided they are already registered under the
> AMBA bus.  I already submitted the generic bridge
> (https://lkml.org/lkml/2012/5/28/194).

Yeah I buy this concept, it's a good way to share this code.

> The cell-id I used in the table are the one for ux500 (only as far as
> I know from the stn-8815 manuals) and the one for STA2X11.

I've tried a few times to get this driver working on the S8815 Calao
dongle version of Nomadik 8815, but failed miserably (I managed
to get DMA and MMC working, which I will likely try to merge.)
I'm still trying to figure out why sometimes now and then.

So this doesn't make anything worse anyway.

Thanks for this nice patch set!

Yours,
Linus Walleij
