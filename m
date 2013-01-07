Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3AGQ7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:59:45 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45234 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3AGQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:59:43 -0500
Date: Mon, 7 Jan 2013 17:59:34 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Dan Williams <djbw@fb.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/16] various fixes and updates for ste_dma40
Message-ID: <20130107165934.GA16374@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dan Williams <djbw@fb.com>,
	Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
 <20130107143356.GB15804@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107143356.GB15804@intel.com>
X-Operating-System: Linux balto 3.8.0-rc2-00036-g5f73896 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 06:33:56AM -0800, Vinod Koul wrote:
> On Mon, Jan 07, 2013 at 12:21:42PM +0100, Fabio Baltieri wrote:
> > Hi all,
> > 
> > this series contains many fixes and updates for the ste_dma40 driver.
> > 
> > The first patches of the series were originally sent weeks ago but did not
> > receive any feedback, so I'm also resending those, but I've rebased everything
> > on top of v3.8-rc2 to avoid a (trivial) file rename conflict.
> > 
> > Vinod, these should probably end up in the arm-soc tree so they can receive
> > some testing from drivers using it.  Can I have your Acked-by for this?
> Sure the patchset looks fine by me
> 
> Acked-by: Vinod Koul <vinod.koul@intel.com>

Thanks Vinod!

Linus, will you pick this up in ste-next for arm-soc?

Thanks,
Fabio

-- 
Fabio Baltieri
