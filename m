Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2DPRdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:33:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:8898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab2DPRdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130245599"
Date: Mon, 16 Apr 2012 19:42:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Subject: Re: [PATCH 1/2] mfd/db5500-prcmu: delete DB5500 PRCMU support
Message-ID: <20120416174235.GS24130@sortiz-mobl>
References: <1334564854-6102-1-git-send-email-linus.walleij@stericsson.com>
 <CACRpkdZuTJHQSFoLjjVjewtz6YR3gLmeGrP-RY+GfN1y1RzR_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZuTJHQSFoLjjVjewtz6YR3gLmeGrP-RY+GfN1y1RzR_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Apr 16, 2012 at 01:18:15PM +0200, Linus Walleij wrote:
> On Mon, Apr 16, 2012 at 10:27 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> 
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > This platform has been obsoleted and was only available inside of
> > ST-Ericsson, no users of this code are left in the world. This
> > deletes the core U5500 support entirely in the same manner as the
> > obsoleted U8500 silicon was previously deleted.
> >
> > Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> > Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> > Cc: Jonas Aberg <jonas.aberg@stericsson.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Ulf Hansson <ulf.hansson@stericsson.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> BTW Sam, these have cross-dependencies on stuff happening in arch/arm/mach-ux500
> so if I can get ACKs for this it's better if I merge it through the
> AMR SoC tree.
Argh, and I thought I would get to apply the jumbo code deleting patches ;)
Please add my Acked-by: Samuel Ortiz <sameo@linux.intel.com> to both of them.


> HOWEVER: if you apply Axel Lin's patch reording all the KConfig entries, that
> will *not* work, we might have to merge this during the merge window in that
> case, so I want to know how to proceed here ... if the Kconfig patch is applied
> to the -rc:s or postponed, I can merge these two patches.
I can postpone Axel's patch, and have it merged as a 2nd pull request during
the next merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
