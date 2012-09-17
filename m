Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2IQJAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:00:34 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:49959 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2IQJAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:00:33 -0400
Date: Mon, 17 Sep 2012 10:58:50 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] gpio: pl061 depends on ARM
Message-ID: <20120917085850.GE17079@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com> <1347639843-32119-3-git-send-email-dciminaghi@mail.gnudd.com> <505372E0.1040906@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <505372E0.1040906@mvista.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:09:36PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 09/14/2012 08:23 PM, Davide Ciminaghi wrote:
> 
> > From: Alessandro Rubini <rubini@gnudd.com>
> 
> > Patch dece904d itroduced chained_irq_enter/exit, which is only
> 
>   Rather commit dece904d. And you need to also specify its summary in parens.
>
ok, will fix this

Thanks and regards
Davide
