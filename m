Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2K1QEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:04:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44201 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2K1QEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:04:49 -0500
MIME-Version: 1.0
In-Reply-To: <1353716576-19783-1-git-send-email-ciminaghi@gnudd.com>
References: <CAOh2x=keCbnPQzxB+AT5hEt_ukQ6GhPLuxkaQJCML27H9LbWwg@mail.gmail.com>
	<1353716576-19783-1-git-send-email-ciminaghi@gnudd.com>
Date: Wed, 28 Nov 2012 17:04:44 +0100
Message-ID: <CACRpkdYFfPVogqW3UTP4CU-ZfBE7_awGOYxcTZiTRrq-49FdwA@mail.gmail.com>
Subject: Re: [PATCH 3/8 v3] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
From: Linus Walleij <linus.walleij@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: viresh.linux@gmail.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 1:22 AM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:

> From: Alessandro Rubini <rubini@gnudd.com>
>
> The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> moves it where it can be accessed by other architectures, and fixes
> all users.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

OK!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
