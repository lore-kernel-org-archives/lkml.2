Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0F0VYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 17:24:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:61024 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab0F0VYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 17:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,492,1272870000"; 
   d="scan'208";a="812121550"
Date: Sun, 27 Jun 2010 23:24:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>,
       Rabin VINCENT <rabin.vincent@stericsson.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/5 V7] input: STMPE touch controller support
Message-ID: <20100627212405.GA9264@sortiz-mobl>
References: <20100624162407.GA18899@core.coreip.homeip.net>
 <1277455071-8572-1-git-send-email-l.fu@pengutronix.de>
 <20100625091116.GE8546@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625091116.GE8546@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, Jun 25, 2010 at 02:11:16AM -0700, Dmitry Torokhov wrote:
> On Fri, Jun 25, 2010 at 10:37:51AM +0200, Luotao Fu wrote:
> > +
> > +	/* 
> 
> Trailing whitespace.
> 
> > +	 * touch_det sometimes get desasserted or just get stuck. This appears
> > +	 * to be a silicon bug, We still have to clearify this with the
> > +	 * manufacture. As a workaround We release the key anyway if the
> > +	 * touch_det keeps coming in after 4ms, while the FIFO contains no value
> > +	 * during the whole time. 
> 
> Trailing whitespace.
> 
> > +
> > +static int stmpe_init_hw(struct stmpe_touch *ts)
> 
> __devinit.
> 
> Otherwise:
> 
> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> I assume it will be merged through MFD tree?
Yes, that's correct.

Cheers,
Samuel.


> -- 
> Dmitry

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
