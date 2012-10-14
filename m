Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab2JNSUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:20:43 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:39656 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JNSUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:20:42 -0400
Date: Sun, 14 Oct 2012 20:19:41 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121014201941.22284249@neptune.home>
In-Reply-To: <507AFE69.70405@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<20121014104138.7e8a9c59@neptune.home>
	<507A997D.7070508@cfl.rr.com>
	<20121014130323.06f0225d@neptune.home>
	<507AEE4A.1000907@cfl.rr.com>
	<20121014192253.5a7517ef@neptune.home>
	<507AFE69.70405@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> >> And could I ask if this simple pgm might work to build the file I need?
> >
> > It looks fine. You can also check the output with hexdump just to
> > make sure it looks sane.
> 
> Did that and the data looks swapped compared to the array written, but I 
> guess that's normal?

That might very well be presentation issue, how did you call hexdump?
When called with no arguments but filename it groups bytes as words and
those look swapped (on little-endian), but `hexdump -C $file` is fine,
dumping each byte individually.

> > If it's broken kernel will tell you that checksum does not match.
> >
> 
> So the  check sum is actually already in the data provided by the service 
> manual then.

Yes, checksum byte is part of the EDID blob.

Bruno

> > In any case the (successful) loading of edid should be visible in kernel
> > log.
> >
> 
> I'll be trying this a little later in the day.
> 
> Thanks again
> Mark
