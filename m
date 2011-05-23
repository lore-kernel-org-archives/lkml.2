Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1EWXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:21:51 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45537 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755782Ab1EWXVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:21:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=J+8wbq0WzIbN3HuIn9Wb981Io2yR8rx3bYw1ne0YCBUsPiOBQ1sfl+x9NVFg6wIsW3+tse6VVwX8GEsTdb5slTpr/LN/o3c6VEzpFx2HkEAsEaCEjizZR9mMmJ5AoEk7;
Date: Mon, 23 May 2011 16:21:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
Message-Id: <20110523162143.fdf2f2a7.rdunlap@xenotime.net>
In-Reply-To: <20110523231721.GM10009@thunk.org>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<20110523231721.GM10009@thunk.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 19:17:21 -0400 Ted Ts'o wrote:

> On Mon, May 23, 2011 at 01:33:48PM -0700, Linus Torvalds wrote:
> > On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > I really hope there's also a voice that tells you to wait until .42 before
> > > cutting 3.0.0! :-)
> > 
> > So I'm toying with 3.0 (and in that case, it really would be "3.0",
> > not "3.0.0" - the stable team would get the third digit rather than
> > the fourth one.
> 
> If we change from 2.6.X to 3.X, then if we don't change anything else,
> then successive stable release will cause the LINUX_VERSION_CODE to be
> incremented.  This isn't necessary bad, but it would be a different
> from what we have now.


It's just another little thing to break several scripts...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
