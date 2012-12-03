Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2LCNda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:33:30 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:49437 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2LCNd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:33:29 -0500
Date: Mon, 3 Dec 2012 14:31:50 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
Message-ID: <20121203133150.GC12290@mail.gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com> <1353683310-23654-3-git-send-email-ciminaghi@gnudd.com> <CACRpkdZAW_O0AoZD=uOHu7BmEAAbmbc8kLqWfm7iDQrs0TgRdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACRpkdZAW_O0AoZD=uOHu7BmEAAbmbc8kLqWfm7iDQrs0TgRdA@mail.gmail.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 04:11:08PM +0100, Linus Walleij wrote:
> On Fri, Nov 23, 2012 at 4:08 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> 
> > From: Alessandro Rubini <rubini@gnudd.com>
> >
> > Commit dece904d (gpio: pl061: use chained_irq_* functions in irq
> > handler) introduced chained_irq_enter/exit, which is only
> > available for arch/arm and the driver won't compile elsewhere.
> >
> > The dependency is thus made explicit, because AMBA is used in the x86
> > world by a PCI-to-AMBA bridge, to be submitted.
> >
> > Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> > Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> 
> Patch applied with Viresh's ACK.
>
ok thanks a lot and regards

Davide
