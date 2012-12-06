Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2LFKrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:47:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58313 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926Ab2LFKrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:47:35 -0500
Date: Thu, 6 Dec 2012 10:47:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Armando Visconti <armando.visconti@st.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
 ARCH < v6
Message-ID: <20121206104710.GB749@mudshark.cambridge.arm.com>
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com>
 <50BCD6DB.2030200@st.com>
 <20121203172553.GC14363@n2100.arm.linux.org.uk>
 <20121203174617.GL20074@mudshark.cambridge.arm.com>
 <20121205195134.GD3384@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121205195134.GD3384@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 07:51:34PM +0000, Uwe Kleine-König wrote:
> Hello,

Hi Uwe,

> On Mon, Dec 03, 2012 at 05:46:17PM +0000, Will Deacon wrote:
> > I think Uwe also requires some of the stuff there for his M3 port.
> I didn't check more context than available in the patch and I also
> didn't double-check the M3-docs, but AFAIK the M3 doesn't have a cp15
> and I noopt this code out.

I was thinking more about the word-at-a-time stuff, which relies on
efficient unaligned access for the dcache accesses.

Will
