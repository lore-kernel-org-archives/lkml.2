Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2IQDKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:10:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:63758 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab2IQDKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="193738560"
Subject: Re: [PATCH 1/8] DMA: PL330: use prefix in reg names to build under
 x86
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        giancarlo.asnaghi@st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1347639843-32119-2-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
	 <1347639843-32119-2-git-send-email-dciminaghi@mail.gnudd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 08:36:06 +0530
Message-ID: <1347851166.1943.122.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 18:23 +0200, Davide Ciminaghi wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
> 
> This driver would not compile if ARM_AMBA is selected under x86,
> because "CS" and "DS" are already defined there.  But AMBA
> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
> 
> The patch adds the "PL330_" prefix to all register and bit fields,
> so it can be built by randomconfig after ARM_AMBA appears within x86.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod

