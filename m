Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2LMBRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:17:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55145 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab2LMBRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:17:11 -0500
Message-ID: <50C92C61.8060104@zytor.com>
Date: Wed, 12 Dec 2012 17:16:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Davide Ciminaghi <ciminaghi@gnudd.com>,
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
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <50C92366.8030604@zytor.com> <CACxGe6v97ZnJpggcSE2HEE0S7wZFrYgFW0Hmok7D9h8ByufqGg@mail.gmail.com>
In-Reply-To: <CACxGe6v97ZnJpggcSE2HEE0S7wZFrYgFW0Hmok7D9h8ByufqGg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 05:10 PM, Grant Likely wrote:
> On Thu, Dec 13, 2012 at 12:37 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> OK, so I'm not 100% sure how to best handle this patchset.  I can carry it
>> in the x86 tree with the appropriate ACKs... which could lead to ugly merge
>> conflicts, or we can ask the respective driver authors to take their bits...
>> but that gives a sequencing problem (the core patchset depends on a bunch of
>> outside trees in order to be tested.)
>>
>> Either way it is a late pull for 3.8 at best... however, the risk seems low
>> so *maybe* that is acceptable.
> 
> I'd put the whole series into a separate branch by itself and any
> subsystems with problematic conflicts can merge it into their trees
> also. I'm fine with putting it in the x86 tree for v3.9. I don't think
> there is any huge rush on it.
> 

That was pretty much my preferred option.  I'll put it into tip:x86/amba.

	-hpa


