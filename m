Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2LCQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:57:18 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45145 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2LCQ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:57:16 -0500
Date: Mon, 3 Dec 2012 17:55:53 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rubini@gnudd.com" <rubini@gnudd.com>, "wim@iguana.be" <wim@iguana.be>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "rajeev-dlh.kumar@st.com" <rajeev-dlh.kumar@st.com>,
        "giancarlo.asnaghi@st.com" <giancarlo.asnaghi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/8] mmci: replace readsl/writesl with ioread32_rep/iowrite32_rep
Message-ID: <20121203165553.GA22807@mail.gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com> <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com> <20121203144754.GI20074@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121203144754.GI20074@mudshark.cambridge.arm.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 02:47:54PM +0000, Will Deacon wrote:
> Hi Davide,
> 
> On Fri, Nov 23, 2012 at 03:08:27PM +0000, Davide Ciminaghi wrote:
> > Not all the architectures have readsl/writesl,
> > use the more portable ioread32_rep/iowrite32_rep functions instead.
> 
> I've already got a patch for this in my io branch:
> 
>   https://git.kernel.org/?p=linux/kernel/git/will/linux.git;a=shortlog;h=refs/heads/io
>
oh sorry, didn't know that.
 
> but since I've been dragging my feet on that series, you can also have my
> ack:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
ok thanks and regards
Davide
