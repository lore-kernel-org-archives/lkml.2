Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0IPRrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:47:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab0IPRrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:47:19 -0400
Subject: Re: [RFC][PATCH] Cross Memory Attach
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
	 <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
	 <1284654451.2275.579.camel@laptop>
	 <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
	 <1284657194.2275.585.camel@laptop>
	 <AANLkTikquj_2DE4UhTFAoDxL+1g=_BocCQJ5agrwC4NU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 19:47:07 +0200
Message-ID: <1284659227.2275.595.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 10:34 -0700, Linus Torvalds wrote:
> 
> Of course, these days I would seriously suggest against trying to
> optimize the kmap() case. It only matters on crap hardware these days.
> Anybody running HIGHMEM in 2010 and thinks that it makes sense
> deserves the pain the get. We should not complicate the kernel further
> for it, and sane architectures will have a no-op kmap(). 

OK, fully agreed. Someone ought to tell ARM though :-)

