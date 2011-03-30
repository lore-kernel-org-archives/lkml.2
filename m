Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab1C3Ood (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:44:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65511 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab1C3Ooc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Mar 2011 10:44:32 -0400
Date: Wed, 30 Mar 2011 10:43:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Merge window closed - 2.6.39-rc1 out
Message-ID: <20110330144359.GA16430@dumpdata.com>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
 <20110330120151.GA23358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330120151.GA23358@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D9341AC.00A4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 08:01:51AM -0400, Christoph Hellwig wrote:
> On Tue, Mar 29, 2011 at 02:07:35PM -0700, Linus Torvalds wrote:
> > So 2.6.39-rc1 is out there, and the merge window is closed. I still
> > have to look over the cleancache pull request (which I got in plenty
> > of time, but decided that I want to review after the merge window
> > craziness is over), but other than that, we're done.
> 
> FYI, strong no for me for this one.  None of the comments why it's
> utterly wrong have been addresses, and it hasn't even been posted

<scratches his head>
The one I see is from V3, which was: "but no actual users.". There is code
in zcache (drivers/staging/zcache), and naturally the Xen one that utilize
this API (part of the cleancache API). I am probably missing other ones?

If you meant by "users" real human, there are also reports of folks using it
in Gentoo/SLES, and Oracle's own distro of course. Don't know what the
development version of Gentoo/SLES has right now.

> a single time for review in this merge window.

Nothing in API changed since the last posting:
http://lkml.org/lkml/2010/9/3/383
and linux-next had been working with this patchset.

(you might better using http://archive.eqmx.net/btrfs/Sep10/index.html#msg4439)
to see the thread.

It probably would have been better to repost this "for 2.6.39 review"
but since Andrew Morton put this patchset in his branch it seemed
like it wasn't necessary.
