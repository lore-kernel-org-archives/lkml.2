Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2JGCdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:33:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2JGCdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:33:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121007014447.GB2485@linux.vnet.ibm.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<20121003164712.GF2527@linux.vnet.ibm.com>
	<CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
	<20121003200314.GR2527@linux.vnet.ibm.com>
	<20121004015539.GA19958@srcf.ucam.org>
	<20121004143150.GA2464@linux.vnet.ibm.com>
	<20121005164642.GA10711@linux.vnet.ibm.com>
	<CAFTL4hy434CQhT8WTvKmNzkO4k_isfKQOrCjgfYFYfMVgS7QDw@mail.gmail.com>
	<20121007014447.GB2485@linux.vnet.ibm.com>
Date: Sun, 7 Oct 2012 12:33:48 +1000
Message-ID: <CAPM=9tzoaZ3AWzA6MFnKAMzFgrarWW=JTLHSTzGBf0hoPQ_RmQ@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Dave Airlie <airlied@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Really I would much prefer to add some "Don't enable it unless you're
>> doing kernel hacking.
>> If unsure say N" text in the Kconfig.
>>
>> I can understand that distros want to cover as much feature as they
>> can for their users. But
>> should it be an excuse for not reading outstanding warnings in Kconfig
>> help text?
>
> In my experience, they do not read these warnings carefully.  :-(
> Or perhaps they do read them, but react to them by running the code
> through some test suite rather than by putting full faith in the
> warning.
>

I think Kconfig is mostly what distro would like to use the thing is
the Kconfig text needs to be there upfront when its merged, not two
months later, since then it too late for a distro to notice.

I'd bet most distros would read the warnings, but in a lot of cases
the warning don't exist until its too late.

Dave.


>> Or may be add some specific warning yeah. I wouldn't mind much.
>
> We have some weeks to think about it -- I cannot see pushing a
> warning in as a regression.  ;-)
>
>                                                         Thanx, Paul
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
