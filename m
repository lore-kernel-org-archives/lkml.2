Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2KWP4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:56:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52267 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2KWP4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:56:42 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-5-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-5-git-send-email-ciminaghi@gnudd.com>
Date: Fri, 23 Nov 2012 21:26:41 +0530
X-Google-Sender-Auth: fVQ-1NWVIqibdno6AIZs8f5aIYs
Message-ID: <CAOh2x=mL8NzQuwjpuehbq3TiRp5dddS4fwYRT7OSQVicfLGZyw@mail.gmail.com>
Subject: Re: [PATCH 4/8] watchdog: sp805_wdt depends on ARM
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
> The SP805 driver is only used by the Spear machines, and uses
> writel_relaxed, which is not available on all architectures.
>
> The dependency from CONFIG_ARM avoids compilation problems under
> randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
