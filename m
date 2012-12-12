Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2LLWUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:20:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54802 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2LLWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:20:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121212212124.GB31853@spo001.leaseweb.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <1355146956-6009-4-git-send-email-ciminaghi@gnudd.com> <20121212212124.GB31853@spo001.leaseweb.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 12 Dec 2012 22:20:21 +0000
X-Google-Sender-Auth: Q9PniDbKL43AEDrC-0d-IWqn-1A
Message-ID: <CACxGe6vaAAj_HNc5hzFAk-xL+PA=mj9S3DgL1yArjuQ5-e8iSA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] watchdog: sp805_wdt depends on ARM
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <djbw@fb.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, rubini@gnudd.com,
        Chris Ball <cjb@laptop.org>, David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>, Ben Dooks <ben-linux@fluff.org>,
        Viresh Kumar <viresh.linux@gmail.com>, rajeev-dlh.kumar@st.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 9:21 PM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Davide
>
>> From: Alessandro Rubini <rubini@gnudd.com>
>>
>> The SP805 driver is only used by the Spear machines, and uses
>> writel_relaxed, which is not available on all architectures.
>>
>> The dependency from CONFIG_ARM avoids compilation problems under
>> randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.
>>
>> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
>> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Point of order. Adding Signed-off-by is only appropriate if you have
actually "handled" a patch (ie. either applied it to your own git tree
or you are reposting it). If you're merely stating that you're okay
with the patch then "Acked-by" is what you should use.

Signed-off-by is more properly about asserting that you received the
patch under licensing terms compatible with the current. See
Developer's Certificate of Origin in Documentation/SubmittingPatches
for details.

g.
