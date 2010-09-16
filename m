Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0IPSBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:01:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab0IPSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop> <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
 <1284657194.2275.585.camel@laptop> <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
 <1284659227.2275.595.camel@laptop> <AANLkTi=hFydeqk_ENGmqEqwqduSeN2gpjMr+VpcN38Xx@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Sep 2010 11:00:50 -0700
Message-ID: <AANLkTikjV1Qos4R-84Msqdqiv408mknEWc2PAHtf8fRY@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>   But there is no way I'm
> going to say "oh, HIGHMEM still makes sense in 2010 because the ARM
> guys are now making all the same mistakes Intel did in 1992".

Off by a couple of years. Intel did it wit the PPro, in 1995,
actually. But it's still going to be 16 years later by the time ARM
LPAE actually ships, I guess.

                        Linus
