Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3AGXmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:42:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34428 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3AGXmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:42:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] cpuidle: fix number of initialized/destroyed states
Date: Tue, 08 Jan 2013 00:48:27 +0100
Message-ID: <1723744.LNLEcpXi0l@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50EB52A4.10307@linaro.org>
References: <1357585921-3391-1-git-send-email-krzysiek@podlesie.net> <339419841.p0RXgOP6cW@vostro.rjw.lan> <50EB52A4.10307@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 07, 2013 11:56:36 PM Daniel Lezcano wrote:
> On 01/07/2013 10:58 PM, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Thanks for the patch!
> > 
> > I'd like Daniel to have a look at it still.
> 
> I agree with this patch. I was about to send exactly the same.
> 
> Thanks Krzysztof for fixing this.
> 
> 
> > On Monday, January 07, 2013 08:12:01 PM Krzysztof Mazur wrote:
> >> Commit bf4d1b5ddb78f86078ac6ae0415802d5f0c68f92 (cpuidle: support
> >> multiple drivers) changed the number of initialized state kobjects
> >> in cpuidle_add_state_sysfs() from device->state_count to drv->state_count,
> >> but leaved device->state_count in cpuidle_remove_state_sysfs().
> >> Those two values might have different values, causing for instance
> >> NULL pointer dereference in cpuidle_remove_state_sysfs().
> >>
> >> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

OK, thanks.

I have a pull request for 3.8-rc3 ready, so I'll send this one in the next
round.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
