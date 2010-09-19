Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0ISEzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:55:33 -0400
Received: from snt0-omc3-s4.snt0.hotmail.com ([65.55.90.143]:45007 "EHLO
	snt0-omc3-s4.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab0ISEzb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:55:31 -0400
Message-ID: <SNT125-W50374AE4BF6FD350810298C37D0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <torvalds@linux-foundation.org>, <peterz@infradead.org>
CC: <cyeoh@au1.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH] Cross Memory Attach
Date: Sat, 18 Sep 2010 21:55:30 -0700
Importance: Normal
In-Reply-To: <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
 <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop>
 <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop>,<AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Sep 2010 04:55:31.0283 (UTC) FILETIME=[E2E9D230:01CB57B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Of course, these days I would seriously suggest against trying to
> optimize the kmap() case. It only matters on crap hardware these days.
> Anybody running HIGHMEM in 2010 and thinks that it makes sense
> deserves the pain the get. We should not complicate the kernel further
> for it, and sane architectures will have a no-op kmap().

Well, keep in mind most even vaguely recent 32-bit x86 distro kernels
have HIGHMEM4G enabled by default.
Some recent ones even have HIGHMEM64G enabled in order to get NX support.
(And yes, as I said before, there are many processors that cannot run in long mode
but have NX)

Yuhong Bao
 		 	   		  