Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2LLVVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:21:50 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:36128 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754383Ab2LLVVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:21:49 -0500
Date: Wed, 12 Dec 2012 22:21:24 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, cjb@laptop.org,
        davidb@codeaurora.org, nico@fluxnic.net, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 3/7] watchdog: sp805_wdt depends on ARM
Message-ID: <20121212212124.GB31853@spo001.leaseweb.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <1355146956-6009-4-git-send-email-ciminaghi@gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355146956-6009-4-git-send-email-ciminaghi@gnudd.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide

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

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Kind regards,
Wim.

