Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2ICVpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 17:45:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50267 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ICVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 17:45:48 -0400
Message-ID: <50452508.80008@suse.cz>
Date: Mon, 03 Sep 2012 23:45:44 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Millenbach <jmillenbach@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        team-fjord@googlegroups.com, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCHv2] tty: Added a CONFIG_TTY option to allow removal of
 TTY
References: <1346633072-29361-1-git-send-email-jmillenbach@gmail.com> <50451E0E.1050605@suse.cz> <CADwDc1DXb3o0i-7NGZKFGwKU6Ybj703OHhUWgh0he9TcCFpW4g@mail.gmail.com>
In-Reply-To: <CADwDc1DXb3o0i-7NGZKFGwKU6Ybj703OHhUWgh0he9TcCFpW4g@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 11:24 PM, Joe Millenbach wrote:
> I do not have a Power PC system to test on

Neither do I. But that is no excuse to break it. There are
cross-compilers for instance.

> so during my testing I did
> not notice that option would need TTY also.  Thanks for pointing that
> out.  Before I spin a new patch is there anything else I should add?
> I do not know of a way for me to easily test all the different CPU
> specific configurations on my x86 based machines.

Basically everything that does alloc_tty_driver...

You should minimize the risk of breaking !TTY builds (randconfig for
example) on other arches as much as possible. I'm not trying to force
you to do allmodconfig minus TTY on all arches, but at least do 'git
grep' thoroughly.

thanks,
-- 
js
suse labs
