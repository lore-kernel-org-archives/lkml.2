Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2F2PcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:32:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:40379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab2F2PcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:32:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186645062"
Date: Fri, 29 Jun 2012 17:43:26 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Message-ID: <20120629154326.GM22806@sortiz-mobl>
References: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
 <F45880696056844FA6A73F415B568C69595AD0E365@EXDCVYMBSTM006.EQ1STM.local>
 <CACRpkda916-6ArCb4jVdrhOizNcet9S7j_whGzoOv35CYEYyNw@mail.gmail.com>
 <F45880696056844FA6A73F415B568C69595AD891F5@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C69595AD891F5@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Mon, Jun 04, 2012 at 08:21:25AM +0200, Arun MURTHY wrote:
> > >> Force the Modem wakeup by asserting the CaWakeReq signal before the
> > >> hostaccess_req/ack ping-pong sequence. The Awake_req signal is de-
> > >> asserted
> > >> asserted at the same time than the hostaccess_req. Return error on
> > >> failure
> > >> case so that the client using this can take appropiate steps.
> > >>
> > >> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> > >> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> > >> ---
> > >
> > >
> > > Any Comments?
> > 
> > Have you checked that this applies cleanly to the latest v3.5 HEAD from
> > Torvalds? I think I tried applying at one point and it didn't work.
> > 
> > Otherwise I think it's ripe for Sam to apply?
> > 
> 
> The patch applies as is with no conflict.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
