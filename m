Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0G1FG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:06:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45107 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0G1FGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:06:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: dave b <db.pub.mail@gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <AANLkTin47_htYK8eV-6C4QkRK_U__qYeWX16Ly=YK-0w@mail.gmail.com>
References: <20100727200804.2F40.A69D9226@jp.fujitsu.com> <AANLkTin47_htYK8eV-6C4QkRK_U__qYeWX16Ly=YK-0w@mail.gmail.com>
Message-Id: <20100728135850.7A92.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 28 Jul 2010 14:06:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 27 July 2010 21:14, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> On 27 July 2010 18:09, dave b <db.pub.mail@gmail.com> wrote:
> >> > On 27 July 2010 16:09, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >>> > Do you mean the issue will be gone if disabling intel graphics?
> >> >>> It may be a general issue or it could just be specific :)
> >> >
> >> > I will try with the latest ubuntu and report how that goes (that will
> >> > be using fairly new xorg etc.) it is likely to be hidden issue just
> >> > with the intel graphics driver. However, my concern is that it isn't -
> >> > and it is about how shared graphics memory is handled :)
> >>
> >>
> >> Ok my desktop still stalled and no oom killer was invoked when I added
> >> swap to a live-cd of 10.04 amd64.
> >>
> >> *Without* *swap* *on* - the oom killer was invoked - here is a copy of it.
> >
> > This stack seems similar following bug. can you please try to disable intel graphics
> > driver?
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=14933
> 
> Ok I am not sure how to do that :)
> I could revert the patch and see if it 'fixes' this :)

Oops, no, revert is not good action. the patch is correct. 
probably my explanation was not clear. sorry.

I did hope to disable 'driver' (i.e. using vga), not disable the patch.

Thanks.


