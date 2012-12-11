Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2LKEZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:25:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37462 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2LKEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <1355146956-6009-2-git-send-email-ciminaghi@gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
	<1355146956-6009-2-git-send-email-ciminaghi@gnudd.com>
Date: Tue, 11 Dec 2012 09:55:08 +0530
Message-ID: <CAJe_ZhfE9-kvB9s5=VZ5tgzXa7GsQj_1rt232aCsrfJ-KiTP1g@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] DMA: PL330: use prefix in reg names to build under x86
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: will.deacon@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 19:12, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
>
>     This driver would not compile if ARM_AMBA is selected under x86,
>     because "CS" and "DS" are already defined there.  But AMBA
>     is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
>
>     The patch just adds the "PL330_" prefix to all registers,
>     so it can be built by randomconfig after ARM_AMBA appears within x86.
>     No other technical changes have been performed.
>     The patch was build-tested only.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> [Davide Ciminaghi <ciminaghi@gnudd.com>: only registers prefixed]
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> ---

 Acked-by: Jassi Brar <jassisinghbrar@gmail.com>

Thanks.
