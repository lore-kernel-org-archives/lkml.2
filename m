Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2LMBKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:10:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33122 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2LMBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:10:54 -0500
MIME-Version: 1.0
In-Reply-To: <50C92366.8030604@zytor.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <50C92366.8030604@zytor.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 13 Dec 2012 01:10:32 +0000
X-Google-Sender-Auth: i5SDe8lxEY9pP9Y_K5W5QE3vSA8
Message-ID: <CACxGe6v97ZnJpggcSE2HEE0S7wZFrYgFW0Hmok7D9h8ByufqGg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Dan Williams <djbw@fb.com>, "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, rubini <rubini@gnudd.com>,
        Wim Van Sebroeck <wim@iguana.be>, Chris Ball <cjb@laptop.org>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Ben Dooks <ben-linux@fluff.org>, Viresh Kumar <viresh.linux@gmail.com>,
        "rajeev-dlh.kumar" <rajeev-dlh.kumar@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "giancarlo.asnaghi" <giancarlo.asnaghi@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 12:37 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> OK, so I'm not 100% sure how to best handle this patchset.  I can carry it
> in the x86 tree with the appropriate ACKs... which could lead to ugly merge
> conflicts, or we can ask the respective driver authors to take their bits...
> but that gives a sequencing problem (the core patchset depends on a bunch of
> outside trees in order to be tested.)
>
> Either way it is a late pull for 3.8 at best... however, the risk seems low
> so *maybe* that is acceptable.

I'd put the whole series into a separate branch by itself and any
subsystems with problematic conflicts can merge it into their trees
also. I'm fine with putting it in the x86 tree for v3.9. I don't think
there is any huge rush on it.

g.
