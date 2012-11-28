Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2K1QAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:00:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63913 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2K1QAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:00:36 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-5-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-5-git-send-email-ciminaghi@gnudd.com>
Date: Wed, 28 Nov 2012 17:00:35 +0100
Message-ID: <CACRpkdb1e=4yV6pP1aw_p8vW0MQUDiV5ZQq1TzobyOKZN7gcXQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] watchdog: sp805_wdt depends on ARM
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
> The SP805 driver is only used by the Spear machines, and uses
> writel_relaxed, which is not available on all architectures.
>
> The dependency from CONFIG_ARM avoids compilation problems under
> randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
