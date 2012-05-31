Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab2EaBrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:47:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54401 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab2EaBrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <ca47a47e0a4db31545549ed978e1dc7b3aad4377.1338398567.git.rubini@gnudd.com>
References: <cover.1338398567.git.rubini@gnudd.com>
	<ca47a47e0a4db31545549ed978e1dc7b3aad4377.1338398567.git.rubini@gnudd.com>
Date: Thu, 31 May 2012 09:47:12 +0800
Message-ID: <CACRpkdY_bg5s_eKot8Ywbmb+SmixsJOSJW_jWjjenedjJng4Jg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] i2c-nomadik: move header from <plat/i2c.h> to <linux/i2c-nomadik.h>
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

> The header and driver were only used by arm/mach-nomadik and
> arm/mach-u8500.  The STA2X11 I/O Hub exports on PCIe a number of
> devices, including i2c-nomadik.  This patch allows compilation of
> the driver under x86.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

The new place to put pure platform data headers is:
include/linux/platform_data/i2c-nomadik.h so please use this.

Pls use git format-patch -M so we get a nice movement patch
without all the -/+ lines. (No big deal though.)

Yours,
Linus Walleij
