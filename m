Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2LMCRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:17:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab2LMCRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:17:42 -0500
Message-ID: <50C93A83.8040106@zytor.com>
Date: Wed, 12 Dec 2012 18:16:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Davide Ciminaghi <ciminaghi@gnudd.com>
CC: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <50C93718.2090706@zytor.com>
In-Reply-To: <50C93718.2090706@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 06:02 PM, H. Peter Anvin wrote:
> Hmm... with this patchset on top of v3.7 I still get a bunch of warnings
> and errors.
>
> More details when the build completes (if it does.)  I might still push
> out the branch to let Fengguang's test robot take it for a spin.
>

Build failure:

o.i386-allconfig/make.log:make[4]: *** [drivers/gpio/gpio-pl061.o] Error 1
o.i386-allconfig/make.log:make[3]: *** [drivers/gpio] Error 2

Warnings:

/home/hpa/kernel/tip.x86-amba/drivers/dma/amba-pl08x.c:848:3: warning: 
format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has 
type ‘dma_addr_t’ [-Wformat]
/home/hpa/kernel/tip.x86-amba/drivers/dma/amba-pl08x.c:848:3: warning: 
format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has 
type ‘dma_addr_t’ [-Wformat]
/home/hpa/kernel/tip.x86-amba/arch/x86/pci/sta2x11-fixup.c:186:2: 
warning: initialization from incompatible pointer type [enabled by default]
/home/hpa/kernel/tip.x86-amba/arch/x86/pci/sta2x11-fixup.c:186:2: 
warning: (near initialization for ‘sta2x11_dma_ops.free’) [enabled by 
default]
/home/hpa/kernel/tip.x86-amba/drivers/extcon/extcon-max77693.c:355:10: 
warning: ‘adclow’ may be used uninitialized in this function 
[-Wmaybe-uninitialized]
/home/hpa/kernel/tip.x86-amba/drivers/extcon/extcon-max77693.c:355:10: 
warning: ‘adc1k’ may be used uninitialized in this function 
[-Wmaybe-uninitialized]
/home/hpa/kernel/tip.x86-amba/drivers/extcon/extcon-max77693.c:355:10: 
warning: ‘adc’ may be used uninitialized in this function 
[-Wmaybe-uninitialized]

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

