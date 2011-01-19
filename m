Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1ASQBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:01:14 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42458 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab1ASQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:01:12 -0500
X-Greylist: delayed 19229 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 11:01:12 EST
Date: Wed, 19 Jan 2011 18:01:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: balbi@ti.com, Yang Ruirui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking
 notifier
Message-ID: <20110119160102.GA4629@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110119092011.GA23624@darkstar>
 <AANLkTinNVJXjL9a=Jmp34ktT7OLkGKzpm79j605vvCWe@mail.gmail.com>
 <20110119153057.GB3552@legolas.emea.dhcp.ti.com>
 <AANLkTinV4afVtBfrRoW_UgLyvHpANZWp4P_yzah=WYUc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinV4afVtBfrRoW_UgLyvHpANZWp4P_yzah=WYUc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:38:44PM +0800, Ming Lei wrote:
> Hi,
> 
> 2011/1/19 Felipe Balbi <balbi@ti.com>:
> 
> > that's easy to guess since commit log says it's a problem on Meego
> > kernel.
> 
> OK, it is a specific issue on Meego kernel, so it is better to add
> "Meego " in the patch title.
> 
> >
> >> Are you sure the issue can be reproduced in 2.6.37 or -next tree?
> >>
> >> In mainline code(2.6.37), blocking_notifier_call_chain is only called in
> >> threaded irq handler of otg driver wrt. musb driver, so seems enough.
> >
> > true, but seems like Nokia is using to notify gadget states, which makes
> > a lot of sense when you start thinking about things such as battery
> > charging.
> 
> Please go ahead to submit and merge it into mainline first if it makes
> sense, :-)

isn't it what his patch is already intending to do ? Or do you want them
to send the initial buggy version and only afterwards send the bugfix ?
A bit weird decision wouldn't that be ?

-- 
balbi
