Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1HRSyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:54:06 -0400
Received: from lucidpixels.com ([72.73.18.11]:52890 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab1HRSyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:54:03 -0400
Date: Thu, 18 Aug 2011 14:54:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Jeff Layton <jlayton@samba.org>
cc: Steve French <smfrench@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
In-Reply-To: <20110818145257.035a38e9@barsoom.rdu.redhat.com>
Message-ID: <alpine.DEB.2.02.1108181452080.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
 <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan> <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan> <20110818091140.385a9455@barsoom.rdu.redhat.com>
 <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan> <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com> <alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
 <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com> <alpine.DEB.2.02.1108181413030.7903@p34.internal.lan> <20110818145257.035a38e9@barsoom.rdu.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Aug 2011, Jeff Layton wrote:

> On Thu, 18 Aug 2011 14:18:15 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>>
>
> Like I said, read performance with cifs.ko just plain sucks currently.
>
> Don't look for cifs.ko to achieve anywhere near NFS' performance unless
> you jump through some very odd hoops (like multithreading your workload
> in userspace, etc). cifs.ko just doesn't do a good job of keeping the
> pipe "stuffed" as most calls are handled synchronously. A single task
> can only handle one call on the wire in most cases. The exception here
> is writes, but that just recently changed...
>
> Reads are done using relatively small buffers and then copied to
> pagecache. Part of what I'm working on will be to allow for much larger
> reads directly into the pagecache. That should also help performance
> significantly.


Jeff,

Understood, thank you for the help thus far and the patch to stop the crashing
kernel problem, it is much appreciated, I'll look forward to the new patch sets
to improve the performance of CIFS mounts.

Justin.

>
