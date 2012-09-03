Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2ICVzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 17:55:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ICVzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 17:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <50452508.80008@suse.cz>
References: <1346633072-29361-1-git-send-email-jmillenbach@gmail.com>
	<50451E0E.1050605@suse.cz>
	<CADwDc1DXb3o0i-7NGZKFGwKU6Ybj703OHhUWgh0he9TcCFpW4g@mail.gmail.com>
	<50452508.80008@suse.cz>
Date: Mon, 3 Sep 2012 14:55:20 -0700
Message-ID: <CADwDc1CragerUd_TqPSP6Ye2J+sM=k0148RnEz1ALRS1HJAwjQ@mail.gmail.com>
Subject: Re: [PATCHv2] tty: Added a CONFIG_TTY option to allow removal of TTY
From: Joe Millenbach <jmillenbach@gmail.com>
To: jslaby@suse.cz
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        team-fjord@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 2:45 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 09/03/2012 11:24 PM, Joe Millenbach wrote:
>> I do not have a Power PC system to test on
>
> Neither do I. But that is no excuse to break it. There are
> cross-compilers for instance.

True.  I was not saying I should leave it, only why I did not catch it
sooner and was asking for a better way.

>> so during my testing I did
>> not notice that option would need TTY also.  Thanks for pointing that
>> out.  Before I spin a new patch is there anything else I should add?
>> I do not know of a way for me to easily test all the different CPU
>> specific configurations on my x86 based machines.
>
> Basically everything that does alloc_tty_driver...
>
> You should minimize the risk of breaking !TTY builds (randconfig for
> example) on other arches as much as possible. I'm not trying to force
> you to do allmodconfig minus TTY on all arches, but at least do 'git
> grep' thoroughly.
>
> thanks,
> --
> js
> suse labs

Perfect, I'll go through this list and make sure I've handled all of them.

Thanks for your time,
Joe
