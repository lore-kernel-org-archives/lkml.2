Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab2JDN6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:58:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41989 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab2JDN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:58:36 -0400
Date: Thu, 4 Oct 2012 06:58:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121004135832.GB15525@kroah.com>
References: <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk>
 <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com>
 <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
 <3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
 <CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
 <CA+5PVA5J0OhmSsy3zOi=z8Ck7QJHVXng=q7OZNOu4nzi6qNA-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5J0OhmSsy3zOi=z8Ck7QJHVXng=q7OZNOu4nzi6qNA-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:39:41AM -0400, Josh Boyer wrote:
> > That said, there's clearly enough variation here that I think that for
> > now I won't take the step to disable the udev part. I'll do the patch
> > to support "direct filesystem firmware loading" using the udev default
> > paths, and that hopefully fixes the particular case people see with
> > media modules.
> 
> As you probably noticed, we had a tester in the RH bug report success
> with the commit you included yesterday.
> 
> Do you think this is something worth including in the stable kernels
> after it gets some further testing during the merge window?  Perhaps
> not that specific commit as there seems to be some additional changes
> needed for configurable paths, etc, but a backport of the fleshed out
> changeset might be wanted.
> 
> We have a new enough udev in Fedora 17 to hit this issue with 3.5 and
> 3.6 when we rebase.  I'm sure other distributions will be in similar
> circumstances soon if they aren't already.  Udev isn't going to be
> fixed, so having something working in these cases would be great.

Yes, I don't have a problem taking this into the stable kernel releases
once it gets some testing and fleshed out.  I'll be watching it to see
how it goes.

thanks,

greg k-h
