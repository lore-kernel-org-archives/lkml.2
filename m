Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2K1QeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:34:23 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45011 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab2K1QeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:34:22 -0500
Date: Wed, 28 Nov 2012 17:33:12 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH 5/8] mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep
Message-ID: <20121128163312.GC16612@mail.gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com> <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com> <CACRpkdaWNC0ayN4JbEq63W+KLUdYfH5SmSu8=CNucQNixvmPUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CACRpkdaWNC0ayN4JbEq63W+KLUdYfH5SmSu8=CNucQNixvmPUw@mail.gmail.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 05:08:27PM +0100, Linus Walleij wrote:
> On Fri, Nov 23, 2012 at 4:08 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> 
> > Not all the architectures have readsl/writesl,
> > use the more portable ioread32_rep/iowrite32_rep functions instead.
> >
> > Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> Can't think of anything better, put it in Russell's patch tracker when
> you think you're finished with it.

ok, will do that.

Thanks and regards
Davide
