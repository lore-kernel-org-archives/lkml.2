Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0EaVqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:46:35 -0400
Received: from www.tglx.de ([62.245.132.106]:44724 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0EaVqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:46:34 -0400
Date: Mon, 31 May 2010 23:46:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1275340869.2823.344.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1005312343290.2933@localhost.localdomain>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>  <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>  <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>  <20100527220949.GB10602@srcf.ucam.org>  <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
  <20100527223605.GB11364@srcf.ucam.org>  <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>  <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>  <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>  <1275120618.27810.12699.camel@twins>
  <1275149418.4503.128.camel@mulgrave.site>  <alpine.LFD.2.00.1005312231120.2933@localhost.localdomain> <1275340869.2823.344.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, James Bottomley wrote:
> 
> For MSM hardware, it looks possible to unify the S and C states by doing
> suspend to ram from idle but I'm not sure how much work that is.

On ARM, it's not rocket science and we have in tree support for this
already (OMAP). I have done the same thing on a Samsung part as a
prove of concept two years ago and it's really easy as the hardware is
sane. Hint: It's designed for mobile devices :)

Thanks,

	tglx
