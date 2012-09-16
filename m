Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab2IPWNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:13:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58144 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2IPWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <1347639843-32119-2-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
	<1347639843-32119-2-git-send-email-dciminaghi@mail.gnudd.com>
Date: Mon, 17 Sep 2012 00:13:41 +0200
Message-ID: <CACRpkdYW2jYp4PSRiBQbPSt=U99JQPyb5Y9x57ORM9pgVJYWMg@mail.gmail.com>
Subject: Re: [PATCH 1/8] DMA: PL330: use prefix in reg names to build under x86
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
> This driver would not compile if ARM_AMBA is selected under x86,
> because "CS" and "DS" are already defined there.  But AMBA
> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
>
> The patch adds the "PL330_" prefix to all register and bit fields,
> so it can be built by randomconfig after ARM_AMBA appears within x86.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Looks sound.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
