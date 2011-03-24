Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab1CXEAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:00:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34089 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1CXEA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:00:29 -0400
Date: Wed, 23 Mar 2011 22:00:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bibek BASU <bibek.basu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
Message-ID: <20110324040026.GC27881@ponder.secretlab.ca>
References: <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
 <AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
 <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
 <AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com>
 <AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
 <AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
 <AANLkTikw87uS4w15ZWZOp8bUU1jYwn1xK4tp5cSrpeYH@mail.gmail.com>
 <20110317191132.GA12824@angua.secretlab.ca>
 <4E253D605AF50140A55CF6396EC99A241C1F71BA68@EXDCVYMBSTM005.EQ1STM.local>
 <AANLkTikFfDDyQ+23iw_5Hrawe9METoU90Primnsp=hJ+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikFfDDyQ+23iw_5Hrawe9METoU90Primnsp=hJ+@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 09:29:40AM +0100, Linus Walleij wrote:
> On Fri, Mar 18, 2011 at 4:38 AM, Bibek BASU <bibek.basu@stericsson.com> wrote:
> 
> > I don't know how the latest patch has not reached you. I am reposting the patch and attaching with this mail also.
> > Your concern regarding getting gpio irq base address from platform data is addressed in that patch.
> > Sorry for the confusion.
> 
> Maybe I was following up on the wrong mail thread, I take the blame in
> that case :-/
> 
> And please save the board support patch for later.

I'm ignoring this one for now anyway since I'm not going to pick it up
during the merge window.  Remind me to take another look at it when
the merge window closes.

g.
