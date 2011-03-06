Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1CFMEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:04:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48820 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1CFMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:04:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 0/4] exec: unify native/compat code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110305203040.GA7546@redhat.com>
References: <AANLkTimp=mhedXLdrZFqK2QWYvg7MdmUPj3-Q9m2vtTx@mail.gmail.com> <20110305203040.GA7546@redhat.com>
Message-Id: <20110306210334.6CD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  6 Mar 2011 21:04:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 03/03, Linus Torvalds wrote:
> >
> > On Thu, Mar 3, 2011 at 7:47 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >> I _personally_ don't like "conditional". Its name is based on code logic.
> > >> It's unclear what mean "conditional". From data strucuture view, It is
> > >> "opaque userland pointer".
> > >
> > > I agree with any naming, just suggest a better name ;)
> >
> > Maybe just "struct user_arg_ptr" or something?
> 
> OK, nothing else was suggessted, I assume Kosaki agrees.

Sure. :)

And, I happily reported this series run successfully my testsuite.
Could you please add my tested-by tag?

thanks.


> 
> So rename conditional_ptr to user_arg_ptr.
> 
> Also rename get_user_ptr() to get_user_arg_ptr(). It was suggested to
> use the same "user_arg_ptr" for this helper too, but this is not
> grep-friendly. As for get_ in the name... Well, I can redo again ;)
> But this matches get_user() and this is all what this helper does.
> 
> Otherwise unchanged.
> 
> Oleg.
> 



