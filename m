Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2JDRnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:43:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53299 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279Ab2JDRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:42:57 -0400
X-Sasl-enc: 2T+mu5lDNkSxWTcXM3Qdr2Pn6f2jraa5J1vGImNRw2PG 1349372575
Date: Thu, 4 Oct 2012 10:42:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages -
Message-ID: <20121004174254.GA14301@kroah.com>
References: <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk>
 <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com>
 <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
 <3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
 <CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
 <CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
 <87zk42tab4.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk42tab4.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:29:51AM -0700, Eric W. Biederman wrote:
> There are still quite a few interesting cases that devtmpfs does not
> even think about supporting.  Cases that were reported when devtmpfs was
> being reviewed. 

Care to refresh my memory?

> Additionally the devtmpfs maintainership has not dealt with legitimate
> concerns any better than this firmware issue has been dealt with.  I
> still haven't even hear a productive suggestion back on the hole
> /dev/ptmx mess.

I don't know how to handle the /dev/ptmx issue properly from within
devtmpfs, does anyone?  Proposals are always welcome, the last time this
came up a week or so ago, I don't recall seeing any proposals, just a
general complaint.

thanks,

greg k-h
