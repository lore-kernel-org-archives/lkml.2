Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2GEM3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:29:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51227 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2GEM3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120527205541.GA3164@mail.gnudd.com>
References: <20120527205541.GA3164@mail.gnudd.com>
Date: Thu, 5 Jul 2012 14:29:04 +0200
Message-ID: <CACRpkdaVgtSuGE4Usn-0ggqWp3XG6aLdgashC9rNPSdrhU6U1g@mail.gmail.com>
Subject: Re: [PATCH] gpio-sta2x11: don't use pdata if null
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 10:55 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> If there is no platform data available, the driver shouldn't use the
> pointer or it will oops.  Since things will mostly work nonetheless,
> (the BIOS may have set up the pins properly), I'd better not fail the
> probe even in this case.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Applied.

Thanks,
Linus Walleij
