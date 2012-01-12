Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2ALXXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:23:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab2ALXXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:23:04 -0500
Date: Thu, 12 Jan 2012 15:23:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@chromium.org>, Paul Taysom <taysom@google.com>,
        Olof Johansson <olofj@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Message-Id: <20120112152303.420e723e.akpm@linux-foundation.org>
In-Reply-To: <20120112223544.GC18166@google.com>
References: <1326402935-31002-1-git-send-email-taysom@chromium.org>
	<20120112213830.GB17405@kroah.com>
	<20120112215331.GB18166@google.com>
	<CAGagf4dk4KsZSkaWTO9Yegi=_wRJsYBPgfyks1z=wMZJV8gX0w@mail.gmail.com>
	<20120112223544.GC18166@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 14:35:44 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> Theodore Tso (tytso@google.com) wrote:
> > On Thu, Jan 12, 2012 at 4:53 PM, Mandeep Singh Baines <msb@chromium.org>wrote:
> > 
> > >
> > > Hi Greg,
> > >
> > > What is the conventional way of doing this? There is a lot of good
> > > data in the bug report which might be useful to reviewers. We
> > > couldn't find a de-facto way of referencing the downstream bug database
> > > so we just made up a new field. Sorry. We'll use the correct
> > > field name next time.
> > >
> > 
> > There isn't a "correct field name", since it hasn't been standardized.  I
> > can tell you as an the ext4 maintainer, I've put things like
> > 
> > Addresses-Redhat-Bugzilla: <Bugzilla #>
> > 
> > or
> > 
> > Addresses-Debian-Bug: <debian-bug-number>
> > 
> 
> This seems like a good convention. Its also nice in that it scales to
> the case where the bug is reported by multiple distros.
> 
> For future, we'll use:
> 
> Addresses-ChromiumOS-Bug: http://crosbug.com/<Bug #>
> 
> I included the URL because its small and folks might not know where
> our bug database is.

I put "Addresses <some URL>" into the changelog.  Just in the text body,
not as one of the tag:value pairs at the end of the changelog.

z:/usr/src/git26> git log | grep "Addresses http" | wc -l
121

