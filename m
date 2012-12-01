Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2LAPLM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 10:11:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57601 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2LAPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 10:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-3-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-3-git-send-email-ciminaghi@gnudd.com>
Date: Sat, 1 Dec 2012 16:11:08 +0100
Message-ID: <CACRpkdZAW_O0AoZD=uOHu7BmEAAbmbc8kLqWfm7iDQrs0TgRdA@mail.gmail.com>
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
From: Linus Walleij <linus.walleij@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 4:08 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:

> From: Alessandro Rubini <rubini@gnudd.com>
>
> Commit dece904d (gpio: pl061: use chained_irq_* functions in irq
> handler) introduced chained_irq_enter/exit, which is only
> available for arch/arm and the driver won't compile elsewhere.
>
> The dependency is thus made explicit, because AMBA is used in the x86
> world by a PCI-to-AMBA bridge, to be submitted.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Patch applied with Viresh's ACK.

Yours,
Linus Walleij
