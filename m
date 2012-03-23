Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2CWEX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:23:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53254 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2CWEXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:23:51 -0400
Message-ID: <4F6BFAD2.5020103@gmail.com>
Date: Thu, 22 Mar 2012 21:23:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
References: <4F6600FA.7050005@gmail.com> <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F661E89.5050000@gmail.com> <20120319170122.GG11069@google.com> <CAKFRV=N5cF7MTuSpOjySmGgJNnW2b1tBZeF5W4XckA7dMSXysg@mail.gmail.com>
In-Reply-To: <CAKFRV=N5cF7MTuSpOjySmGgJNnW2b1tBZeF5W4XckA7dMSXysg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 11:17 AM, Justin Mattock wrote:
> Alright!! Will pull that branch as soon as i get to a stable connection
> later today.. as for the patch i probably missed something with the fuzz
> it was generating
>
> Justin P. Mattock
>
> On Mar 19, 2012 10:01 AM, "Tejun Heo" <tj@kernel.org
> <mailto:tj@kernel.org>> wrote:
>
>     On Sun, Mar 18, 2012 at 10:42:33AM -0700, Justin P. Mattock wrote:
>      > >Known problem.  The following pending patchset should fix the
>     problem.
>      > >
>      > > http://thread.gmane.org/gmane.linux.kernel/1263989
>      > >
>      > >Jens?
>      > >
>      > >Thakns.
>      > >
>      >
>      > cool thanks for the info..
>      > I went and applied your patches(all 5) and there is fuzz, and some
>      > errors with linux-next.
>      > seems the suspicious message is still there, but the system boots up
>      > just fine with the patches in.
>      >  maybe manually applying them by hand is what I need to do for -next
>      > so I dont miss anything important with the patch that takes care of
>      > the suspicious message.
>
>     Hmm... weird.  I just double check and the patch series makes the
>     warning go away.  Can you please try the following git branch instead?
>
>       git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git
>     <http://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git> blkcg-stats
>
>     Thanks.
>
>     --
>     tejun

alright! looks like on the main linux-next this warning is 
fixed(assuming your patches have been pushed in).
uname -r 3.3.0-next-20120322-00001-gba6003c

Thanks for the info and help with this!

Justin P. Mattock

