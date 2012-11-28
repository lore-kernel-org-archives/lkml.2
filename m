Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2K1QI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:08:29 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39059 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2K1QI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-6-git-send-email-ciminaghi@gnudd.com>
Date: Wed, 28 Nov 2012 17:08:27 +0100
Message-ID: <CACRpkdaWNC0ayN4JbEq63W+KLUdYfH5SmSu8=CNucQNixvmPUw@mail.gmail.com>
Subject: Re: [PATCH 5/8] mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep
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

> Not all the architectures have readsl/writesl,
> use the more portable ioread32_rep/iowrite32_rep functions instead.
>
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>

Can't think of anything better, put it in Russell's patch tracker when
you think you're finished with it.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
