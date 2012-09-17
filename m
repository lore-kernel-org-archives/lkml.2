Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2IQWC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:02:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34615 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2IQWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:02:25 -0400
Date: Mon, 17 Sep 2012 22:59:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
Message-ID: <20120917215958.GT12245@n2100.arm.linux.org.uk>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com> <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:23:57PM +0200, Davide Ciminaghi wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
> 
> Patch dece904d itroduced chained_irq_enter/exit, which is only
> available for arch/arm and the driver won't compile elsewhere.
> 
> The dependency is thus made explicit, because AMBA is used in the x86
> world by a PCI-to-AMBA bridge, to be submitted.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

The real solution to this is to stop the madness that chained_irq_enter/
chained_irq_exit are both ARM-only.
