Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2BPT30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:29:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62348 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BPT3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:29:25 -0500
MIME-Version: 1.0
In-Reply-To: <8f360fc42e201ccc0ab64aa73ffe9671c9b8963f.1329396583.git.rubini@gnudd.com>
References: <cover.1329396583.git.rubini@gnudd.com>
	<8f360fc42e201ccc0ab64aa73ffe9671c9b8963f.1329396583.git.rubini@gnudd.com>
Date: Thu, 16 Feb 2012 20:29:24 +0100
Message-ID: <CACRpkdYV7-a4o+gucUXEbQb1=MHC-7tZ6Hv+jGcpiTiD1DqQNA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] mfd: Add driver for STA2X11 MFD block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:00 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> +config MFD_STA2X11
> +       bool "STA2X11 multi function device support"
> +       depends on STA2X11
> +       select MFD_CORE
> +       select GPIO_STA2X11

Note: this selects a non-existent driver at this point. (OK no big deal.)

> +/* Give names to GPIO pins, like PXA does, taken from the manual */
> +#define GPIO0                  0
> +#define GPIO1                  1
> +#define GPIO2                  2
(...)

These are too general names I think. It should be clear that this is the
GPIO number relative to this one controller, so I would prefix them
like STA2X11_GPIO0 etc.

Overall the MFD core for STA2X11 is looking pretty good!

Yours,
Linus Walleij
