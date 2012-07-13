Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2GMVOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:14:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39324 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab2GMVOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:14:44 -0400
Date: Fri, 13 Jul 2012 23:14:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120713211440.GB10180@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120713162009.GA10268@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:20:09PM -0400, Jörn Engel wrote:
> > > Logging to partitions is not supported.
> > 
> > That could be useful though. We have a setup here where we create a
> > partition on the block device and install the OS there for testing
> > purposes while leaving room on the device after it for other OS installs
> > and other people to test stuff.
> > 
> > If blockconsole could log to partitions, one could create an additional
> > small partition exactly for such logs.
> > 
> > I don't know how much work adding logging to partitions is though.
> 
> The actual logging shouldn't care one bit.  But abusing the
> partitioning code to detect a blockconsole device would no longer
> work, so some alternative for that is needed.
> 
> What I like about abusing the partitioning code is that blockconsole
> just works, without any command line parameters or other setup, either
> on boot or by pluggin in a new device.  And because our particular use
> case is a dedicated usb stick, we don't mind the drawbacks much.

Ok, actually using a dedicated usb stick obviates the need to log to
partitions - el cheapo usb sticks are ubiquitous. And I didn't realize
the usb stick use case when talking about the partitions example above
so forget what I said, logging to a dedicated usb stick is the easiest.

You probably could mention this in the docs as the most natural use case
for blockconsole if you haven't done so.

[ … ]

> Thanks!  The patch below should do that - provided my brain slightly
> less broken than it must have been yesterday.

Thanks, will run it next week and let you know.

-- 
Regards/Gruss,
    Boris.
