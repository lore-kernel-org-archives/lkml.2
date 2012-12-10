Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2LJW0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:26:22 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:57606 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:26:21 -0500
Date: Mon, 10 Dec 2012 23:25:17 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 2/7] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
Message-ID: <20121210222516.GA31546@mail.gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <1355146956-6009-3-git-send-email-ciminaghi@gnudd.com> <CACRpkdbF6S6nOQFwv+tmS4LXhnnwkQxzmGYmH3Xn6TM4E34r8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACRpkdbF6S6nOQFwv+tmS4LXhnnwkQxzmGYmH3Xn6TM4E34r8g@mail.gmail.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:44:09PM +0100, Linus Walleij wrote:
> On Mon, Dec 10, 2012 at 2:42 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> 
> > From: Alessandro Rubini <rubini@gnudd.com>
> >
> > The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> > under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> > moves it where it can be accessed by other architectures, and fixes
> > all users.
> >
> > Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> > Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> 
> Didn't I already ACK this?
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
yes, sorry. You ack was listed in the cover letter.

 
> Pls ask Vinod to merge this.
> 
ok.

Thanks and regards
Davide
