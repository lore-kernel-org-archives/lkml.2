Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2CWP7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:59:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57986 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2CWP7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com>
References: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 23 Mar 2012 09:58:55 -0600
Message-ID: <CAErSpo4a2xC1aetp=FUgmm1NKJwmxneaLcWkF=YBhf2JNSJCQw@mail.gmail.com>
Subject: Re: Tracking regressions for next release(s)
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 12:01 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> Hi
>
> For a long time (dealing with colleagues) we tracking regressions in
> stable RC versions of the kernel. Because 3.3 is out, and it is time
> thinking about tracking regressions for
> next release. I believe that we need to do some summary and decide on
> further action.
>
> I am interested in the opinion of the developers, testers, and
> everyone involved in the development of the kernel, if they thing that
> tracking regressions and monitoring the quality makes sense,
> especially since I met several times (put it mildly) dislike of such
> work and the bugs are repaired relatively slowly. Perhaps someone has
> comments or proposals for change (in the way of work or me).

I personally find the regression tracking very valuable.  Regressions
are worse than other bugs because they make users (at least this one
:)) hesitant to move to newer kernels, and then we miss out on the
testing we depend on.

Your tracking work helps everybody pay attention to these issues.  I
don't understand opposition to it.

Bjorn
