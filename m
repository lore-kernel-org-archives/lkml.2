Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab2IPWMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:12:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44995 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2IPWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <1347639843-32119-4-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
	<1347639843-32119-4-git-send-email-dciminaghi@mail.gnudd.com>
Date: Mon, 17 Sep 2012 00:11:59 +0200
Message-ID: <CACRpkdbaJ6p7wbW5LukET9kE2=jY5w5s74-duPJR7H-XsPPhZw@mail.gmail.com>
Subject: Re: [PATCH 3/8] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
From: Linus Walleij <linus.walleij@linaro.org>
To: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 6:23 PM, Davide Ciminaghi
<dciminaghi@mail.gnudd.com> wrote:

> From: Alessandro Rubini <rubini@gnudd.com>
>
> The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> moves it where it can be accessed by other architectures, and fixes
> all users.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

It's not really platform data or anything, but as long as the
old Samsung drivers are using it we cannot cut it from the
global scope, and I cannot think of anything better to do
so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
