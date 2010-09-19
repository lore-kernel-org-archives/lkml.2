Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab0ISEo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:44:26 -0400
Received: from snt0-omc3-s25.snt0.hotmail.com ([65.55.90.164]:35596 "EHLO
	snt0-omc3-s25.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab0ISEoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:44:25 -0400
Message-ID: <SNT125-W404716E1C7DD1F32AA10AFC37D0@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <torvalds@linux-foundation.org>, <peterz@infradead.org>
CC: <cyeoh@au1.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH] Cross Memory Attach
Date: Sat, 18 Sep 2010 21:44:25 -0700
Importance: Normal
In-Reply-To: <AANLkTikjV1Qos4R-84Msqdqiv408mknEWc2PAHtf8fRY@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
 <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop>
 <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop>
 <AANLkTikquj_2DE4UhTFAoDxL+,<AANLkTikjV1Qos4R-84Msqdqiv408mknEWc2PAHtf8fRY@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Sep 2010 04:44:25.0236 (UTC) FILETIME=[55EB1D40:01CB57B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Thu, Sep 16, 2010 at 10:54 AM, Linus Torvalds
>  wrote:
> > But there is no way I'm
> > going to say "oh, HIGHMEM still makes sense in 2010 because the ARM
> > guys are now making all the same mistakes Intel did in 1992".
>
> Off by a couple of years. Intel did it wit the PPro, in 1995,
> actually. But it's still going to be 16 years later by the time ARM
> LPAE actually ships, I guess.

Yep, back when the 386 was designed, having 4GB for both physical and virtual address space
(which was what caused HIGHMEM to be needed at all with more than 1GB in the first place)
was not a mistake.
 		 	   		  