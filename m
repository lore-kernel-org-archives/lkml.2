Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0KWHT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:19:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37424 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0KWHTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:19:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
Cc: kosaki.motohiro@jp.fujitsu.com, Anca Emanuel <anca.emanuel@gmail.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4CE36652.50305@leadcoretech.com>
References: <AANLkTi==W_KHL3pd8Cq=ojV=aAAOxi4c=ZkHSednOVyH@mail.gmail.com> <4CE36652.50305@leadcoretech.com>
Message-Id: <20101123161915.7BAD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:19:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>
> >>>> hi KOSAKI Motohiro,
> >>>>
> >>>> is it any test suite or test scripts for test page-reclaim performance?
> >>>>
> >>>> Best,
> >>>> Figo.zhang
> >>>>
> >>>
> >>> There is http://www.phoronix.com
> >>
> >> it is not focus on page-reclaim test, or specially for MM.
> >>>
> >>
> >>
> > 
> > If you want some special test, you have to ask Michael Larabel for that.
> > http://www.phoronix-test-suite.com/
> 
> yes, i see, the phoronix-test-suite is test such as ffmpeg, games. not
> focus on MM.

Hi Figo,

I agree with Anca. Nick's patch will change almost VM behavior. then,
generic performance test suit is better than supecific one.

Thanks.



