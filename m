Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0G0Eqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:46:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50383 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0G0Eqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:46:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: dave b <db.pub.mail@gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <AANLkTi=Aswf+Hp+qfsC2sCo32hU3E2D4zt3-R35BZ=MC@mail.gmail.com>
References: <alpine.DEB.2.00.1007261510320.2993@chino.kir.corp.google.com> <AANLkTi=Aswf+Hp+qfsC2sCo32hU3E2D4zt3-R35BZ=MC@mail.gmail.com>
Message-Id: <20100727134431.2F11.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Jul 2010 13:46:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 27 July 2010 08:12, David Rientjes <rientjes@google.com> wrote:
> > On Tue, 27 Jul 2010, dave b wrote:
> >
> >> Actually it turns out on 2.6.34.1 I can trigger this issue. What it
> >> really is, is that linux doesn't invoke the oom killer when it should
> >> and kill something off. This is *really* annoying.
> >>
> >
> > I'm not exactly sure what you're referring to, it's been two months and
> > you're using a new kernel and now you're saying that the oom killer isn't
> > being utilized when the original problem statement was that it was killing
> > things inappropriately?
> 
> Sorry about the timespan :(
> Well actually it is the same issue. Originally the oom killer wasn't
> being invoked and now the problem is still it isn't invoked - it
> doesn't come and kill things - my desktop just sits :)
> I have since replaced the hard disk - which I thought could be the
> issue. I am thinking that because I have shared graphics not using KMS
> - with intel graphics - this may be the root of the cause.

Do you mean the issue will be gone if disabling intel graphics?
if so, we need intel graphics driver folks help. sorry, linux-mm folks don't
know intel graphics detail.


