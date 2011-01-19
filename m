Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1ASPjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:39:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47054 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ASPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jHv/P/q/Q/xqUUzxc4ds6gAk1JHaVsHqiyj8KKhSCUYBbK4ANxMi1ZYIcgTpdb4Vj6
         oslEeFrmEAoPbIfoIX7izuGdZBxng9tNuSsGFflEKJoKPzMXt33GVCn3ZgBrUdffl86o
         tt4hxIBRhn5uoDUZ8enAqmaGqWa3/04jlUIKI=
MIME-Version: 1.0
In-Reply-To: <20110119153057.GB3552@legolas.emea.dhcp.ti.com>
References: <20110119092011.GA23624@darkstar>
	<AANLkTinNVJXjL9a=Jmp34ktT7OLkGKzpm79j605vvCWe@mail.gmail.com>
	<20110119153057.GB3552@legolas.emea.dhcp.ti.com>
Date: Wed, 19 Jan 2011 23:38:44 +0800
Message-ID: <AANLkTinV4afVtBfrRoW_UgLyvHpANZWp4P_yzah=WYUc@mail.gmail.com>
Subject: Re: [PATCH] usb otg: use atomic notifier instead of blocking notifier
From: Ming Lei <tom.leiming@gmail.com>
To: balbi@ti.com
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/1/19 Felipe Balbi <balbi@ti.com>:

> that's easy to guess since commit log says it's a problem on Meego
> kernel.

OK, it is a specific issue on Meego kernel, so it is better to add
"Meego " in the patch title.

>
>> Are you sure the issue can be reproduced in 2.6.37 or -next tree?
>>
>> In mainline code(2.6.37), blocking_notifier_call_chain is only called in
>> threaded irq handler of otg driver wrt. musb driver, so seems enough.
>
> true, but seems like Nokia is using to notify gadget states, which makes
> a lot of sense when you start thinking about things such as battery
> charging.

Please go ahead to submit and merge it into mainline first if it makes
sense, :-)

thanks,
-- 
Lei Ming
