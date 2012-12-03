Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2LCOsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:48:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44768 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab2LCOsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:48:06 -0500
Date: Mon, 3 Dec 2012 14:47:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
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
Subject: Re: [PATCH 5/8] mmci: replace readsl/writesl with
 ioread32_rep/iowrite32_rep
Message-ID: <20121203144754.GI20074@mudshark.cambridge.arm.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
 <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353683310-23654-6-git-send-email-ciminaghi@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Fri, Nov 23, 2012 at 03:08:27PM +0000, Davide Ciminaghi wrote:
> Not all the architectures have readsl/writesl,
> use the more portable ioread32_rep/iowrite32_rep functions instead.

I've already got a patch for this in my io branch:

  https://git.kernel.org/?p=linux/kernel/git/will/linux.git;a=shortlog;h=refs/heads/io

but since I've been dragging my feet on that series, you can also have my
ack:

  Acked-by: Will Deacon <will.deacon@arm.com>

I should get round to sending another version of that lot soon.

Will
