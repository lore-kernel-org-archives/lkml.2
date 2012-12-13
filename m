Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2LMAkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:40:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54884 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab2LMAkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:40:05 -0500
Message-ID: <50C92366.8030604@zytor.com>
Date: Wed, 12 Dec 2012 16:37:58 -0800
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
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
In-Reply-To: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so I'm not 100% sure how to best handle this patchset.  I can carry 
it in the x86 tree with the appropriate ACKs... which could lead to ugly 
merge conflicts, or we can ask the respective driver authors to take 
their bits... but that gives a sequencing problem (the core patchset 
depends on a bunch of outside trees in order to be tested.)

Either way it is a late pull for 3.8 at best... however, the risk seems 
low so *maybe* that is acceptable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

