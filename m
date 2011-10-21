Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1JUUKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 16:10:32 -0400
Received: from mail.lang.hm ([64.81.33.126]:39447 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1JUUKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 16:10:31 -0400
Date: Fri, 21 Oct 2011 13:10:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: NeilBrown <neilb@suse.de>
cc: Alan Stern <stern@rowland.harvard.edu>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lsusd - The Linux SUSpend Daemon
In-Reply-To: <20111021162340.669742c0@notabene.brown>
Message-ID: <alpine.DEB.2.02.1110211308130.13493@asgard.lang.hm>
References: <20111020111743.13b40558@notabene.brown> <Pine.LNX.4.44L0.1110201019500.2081-100000@iolanthe.rowland.org> <20111021162340.669742c0@notabene.brown>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, NeilBrown wrote:

> Hi,
>
> I wasn't going to do this... but then I did.  I think that sometimes coding is
> a bit like chocolate.
>
> At:
>    git://neil.brown.name/lsusd
> or
>    http://neil.brown.name/git/lsusd
>
> you can find a bunch of proof-of-concept sample code that implements a
> "Linux SUSpend Daemon" with client support library and test programs.
>
> I haven't actually tested it as root and had it actually suspend and resume
> and definitely haven't had it even close to a race condition, but the
> various bits seem to work with each other properly when I run them under
> strace and watch.
>
> It didn't turn out quite the way I imagined, but then cold harsh reality has
> a way of destroying our dreams, doesn't it :-)
>
>
> Below is the README file.  Comment welcome as always.
> I'm happy for patches too, but I'm equally happy for someone to re-write it
> completely and make something really useful and maintainable.

have you put any thought into the idea of extending this slightly to 
handle the userspace wakelock interface to potentially allow this to run 
android userspace on a stock kernel?

I realize that there are other things that would be needed as well, but 
the wakelock interface is a biggie.

David Lang
