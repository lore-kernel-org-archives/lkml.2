Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2KWPvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:51:46 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40162 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2KWPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-2-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-2-git-send-email-ciminaghi@gnudd.com>
Date: Fri, 23 Nov 2012 21:21:44 +0530
X-Google-Sender-Auth: 0sj-g0zkFR2xQVYHQkJNoyTJ-sY
Message-ID: <CAOh2x=ncwZNQDKvFia_yrCmmDJ1Kkk+wP4fhcdeo_YtE97ridA@mail.gmail.com>
Subject: Re: [PATCH 1/8] DMA: PL330: use prefix in reg names to build under x86
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
> This driver would not compile if ARM_AMBA is selected under x86,
> because "CS" and "DS" are already defined there.  But AMBA
> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
>
> The patch adds the "PL330_" prefix to all register and bit fields,
> so it can be built by randomconfig after ARM_AMBA appears within x86.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Hi Davide,

Its impossible to review due to obvious reasons :)

Though git provides an option to people to review such stuff easily.

git diff HEAD^.. --word-diff

and HEAD being the commit in discussion.

Problem, is people reviewing it need to apply it and not everybody
can do that. Don't know if adding this diff after the three --- line,
which form the non-commit log would be the right solution ?

--
viresh
