Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0IWR35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:29:57 -0400
Received: from xenotime.net ([72.52.115.56]:50464 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755813Ab0IWR34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:29:56 -0400
Date: Thu, 23 Sep 2010 10:29:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Valdis.Kletnieks@vt.edu, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-22 - build error in drivers/staging/zram
Message-Id: <20100923102951.af83812d.rdunlap@xenotime.net>
In-Reply-To: <20100923160423.06c5bf34.sfr@canb.auug.org.au>
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
	<56264.1285212366@localhost>
	<20100922204305.2fdc5b66.akpm@linux-foundation.org>
	<20100923042134.GA29818@kroah.com>
	<20100922212653.6f55104c.akpm@linux-foundation.org>
	<20100923160423.06c5bf34.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 16:04:23 +1000 Stephen Rothwell wrote:

> Hi Andrew,
> 
> On Wed, 22 Sep 2010 21:26:53 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ooh, intentional dumbness!
> 
> :-)
> 
> > What was the reasoning?
> 
> It was done when the staging stuff was added to linux-next - otherwise my
> builds (and many others) would fail most of the time (it may be better
> now, but at the beginning, there was a lot of mess in staging).

There is still a lot of mess there.  Probably best to leave the kconfig as is
for now, for the benefit of linux-next.

> The reasoning is that build failures in staging should in no way hold up
> the rest of our development.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
