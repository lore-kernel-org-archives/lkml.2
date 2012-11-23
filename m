Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2KWP5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:57:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41214 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2KWP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-3-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-3-git-send-email-ciminaghi@gnudd.com>
Date: Fri, 23 Nov 2012 21:27:09 +0530
X-Google-Sender-Auth: pXdta0w4peti1V2qPmXs3wUk3FM
Message-ID: <CAOh2x==YCgecQi5CMJ3KRH6zxmvM2GRLR2TBcnWzznQFyHoyOQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
From: viresh kumar <viresh.kumar@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 8:38 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
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

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
