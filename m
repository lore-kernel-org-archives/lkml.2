Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2LMSQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:16:24 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:42879 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab2LMSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:16:23 -0500
Date: Thu, 13 Dec 2012 19:14:49 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: ciminaghi@gnudd.com, jaswinder.singh@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        djbw@fb.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, wim@iguana.be, cjb@laptop.org,
        davidb@codeaurora.org, nico@fluxnic.net, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
Message-ID: <20121213181449.GA15966@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <50C93A83.8040106@zytor.com>
References: <50C93A83.8040106@zytor.com>
  <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <50C93718.2090706@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> Build failure:
> 
> o.i386-allconfig/make.log:make[4]: *** [drivers/gpio/gpio-pl061.o] Error 1
> o.i386-allconfig/make.log:make[3]: *** [drivers/gpio] Error 2

This happens because the pl061 is not in this checkout.

I also got a message from the "kbuild test robot", which results from
the same kind of problem.

I'll check the details later, identifying the missing patches and whether
there are remaining warnings.

> /home/hpa/kernel/tip.x86-amba/arch/x86/pci/sta2x11-fixup.c:186:2: 
> warning: initialization from incompatible pointer type [enabled by default]

This is a long-standing problem, but with not practical effects. I
proposed a pair of different fixes quite some months ago. I'll respin
the problem tomorrow.

/alessandro
