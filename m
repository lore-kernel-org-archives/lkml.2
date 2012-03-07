Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589Ab2CGBnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:43:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35055 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2CGBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:43:16 -0500
MIME-Version: 1.0
In-Reply-To: <1331084302.11248.338.camel@twins>
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins>
 <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com> <1331084302.11248.338.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 17:42:55 -0800
X-Google-Sender-Auth: c8uRx3ws5XjDZC8Chs340HRAgEw
Message-ID: <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 5:38 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
>> I do agree that reverting is probably safer at this point, but can we
>> get agreement on this?
>
> I agree with reverting, shoot it in the head :-) Do you want a git
> thingy?

Well, it's less a "git thingy" and more that there are tons of people
involved with the original commit that haven't even piped up.

Srivatsa, Ingo, Prashanth..

In fact, I notice that Prashanth doesn't even seem to have been cc'd,
even if he's the original reporter of the commit that gets reverted.
Added (see lkml)

            Linus
