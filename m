Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1KAMTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:19:12 -0400
Received: from serv04.lahn.de ([213.239.197.57]:45910 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1KAMTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:19:11 -0400
Date: Tue, 1 Nov 2011 13:18:49 +0100
From: Michael Leun <ml@newton.leun.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        nigel@tuxonice.net
Subject: Re: What about bugzilla.kernel.org / Bug 37142 / Tuxonice developer
 going to quit development
Message-ID: <20111101131849.668e0115@xenia.leun.net>
In-Reply-To: <CAFLxGvxeofy58Zuo9rGuXsiQMitJp890T0vwkDzoLHQ3im63ZA@mail.gmail.com>
References: <20111101111420.1667f3aa@xenia.leun.net>
	<CAFLxGvxeofy58Zuo9rGuXsiQMitJp890T0vwkDzoLHQ3im63ZA@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 1 Nov 2011 13:01:58 +0100
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> On Tue, Nov 1, 2011 at 11:14 AM, Michael Leun <ml@newton.leun.net>
> wrote:
> > Rafael, Richard: What do you think is the current state of this bug?
> > Was it ever fixed for you?
> 
> No.
> 
> But I'm quite sure that my netbook is causing the issue.
> Now I can reproduce the error after 1-2 s2disk runs.
> A few months ago 10-20 runs were needed.
> My netbook seesm to die. :-(
> 
> But I'll retest the issue with kernel 2.6.37.4. Currently I'm using
> 3.1.

I doubt that is related to HW, because I can reproduce on at least two,
if not 3 different machines and on the two where it matters to me using 
tuxonice fixed it.

So, you might want to try if you can cure your dying HW with some
tuxonice ;-)

With 3.1 it also takes me one or two tries to see an corruption (create
md5 over some *bin* and *lib* stuff, suspend, resume, check md5sum and
if there are faults throw away caches, what "fixes" the errors seen if
the file affected is not currently opened).

But regarding the question who needs tuxonice, to be honest:

OK, at the moment there is this bug, but if that would not be there I
clearly would prefer the in kernel solution and in fact before there
was this bug I used uswsusp.

I happily would take the additional features of tuxonice if available
in the vanilla kernel, but for me there are no additional features in
tuxonice which justify for dealing with an out of tree patch all the
time.

-- 
MfG,

Michael Leun

