Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab2INSKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:10:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48860 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077Ab2INSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:10:52 -0400
Message-ID: <505372E0.1040906@mvista.com>
Date: Fri, 14 Sep 2012 22:09:36 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
CC: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com> <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com>
In-Reply-To: <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/14/2012 08:23 PM, Davide Ciminaghi wrote:

> From: Alessandro Rubini <rubini@gnudd.com>

> Patch dece904d itroduced chained_irq_enter/exit, which is only

  Rather commit dece904d. And you need to also specify its summary in parens.

> available for arch/arm and the driver won't compile elsewhere.

> The dependency is thus made explicit, because AMBA is used in the x86
> world by a PCI-to-AMBA bridge, to be submitted.

> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

WBR, Sergei

