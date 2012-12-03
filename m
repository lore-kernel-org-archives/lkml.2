Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2LCR2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:28:02 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51504 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab2LCR2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:28:00 -0500
Date: Mon, 3 Dec 2012 18:27:57 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Tux9 <tuxding@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Message-ID: <20121203172757.GA2621@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
 <20121130213906.GB2603@local>
 <201212031035.07778.vitas@nppfactor.kiev.ua>
 <201212031053.45700.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212031053.45700.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:53:45AM +0200, Vitalii Demianets wrote:
> > On Friday 30 November 2012 23:39:06 Hans J. Koch wrote:
> > > Thanks a lot for reporting and discussing that problem. I'll add a
> > >
> > > Reported-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
> > >
> > > if you have no objections.
> >
> > No objections. Thanks, Hans.
> 
> By the way, what do you think about my revised version of uio_pdrv_genirq.c 
> patch from November 29th?

I hope I find the time to look at that later tonight. I'm a bit busy ATM.

Hans
