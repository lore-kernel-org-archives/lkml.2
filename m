Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2LJVoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:44:17 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38368 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LJVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <1355146956-6009-3-git-send-email-ciminaghi@gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
	<1355146956-6009-3-git-send-email-ciminaghi@gnudd.com>
Date: Mon, 10 Dec 2012 22:44:09 +0100
Message-ID: <CACRpkdbF6S6nOQFwv+tmS4LXhnnwkQxzmGYmH3Xn6TM4E34r8g@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
From: Linus Walleij <linus.walleij@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 2:42 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:

> From: Alessandro Rubini <rubini@gnudd.com>
>
> The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> moves it where it can be accessed by other architectures, and fixes
> all users.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Didn't I already ACK this?
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Pls ask Vinod to merge this.

Yours,
Linus Walleij
