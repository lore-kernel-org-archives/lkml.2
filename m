Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0G0GJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:09:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46760 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0G0GJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:09:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: dave b <db.pub.mail@gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <AANLkTimdLbwvRNU09s+LfauREBaxyXBUE5jSmwnpCj8e@mail.gmail.com>
References: <20100727134431.2F11.A69D9226@jp.fujitsu.com> <AANLkTimdLbwvRNU09s+LfauREBaxyXBUE5jSmwnpCj8e@mail.gmail.com>
Message-Id: <20100727150138.2F20.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Jul 2010 15:09:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you mean the issue will be gone if disabling intel graphics?
> > if so, we need intel graphics driver folks help. sorry, linux-mm folks don't
> > know intel graphics detail.
> 
> Well the only other system I have running the 2.6.34.1 kernel atm is
> an arm based system.
> I originally sent this to the kernel list and was told I should
> probably forward it to the mm list.
> It may be a general issue or it could just be specific :)

Hmm.. I'm puzzled 8-)

I don't understand why other all people can't reproduce your issue
even though your reproduce program is very simple.

So, I'm guessing there is hidden reproduce condition. but I have no
idea to find it.



