Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0IXGhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:37:13 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:37344 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564Ab0IXGhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:37:12 -0400
Date: Thu, 23 Sep 2010 23:36:16 -0700
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: rtl8187se: r8180.h: fixed alot of
 checkpatch.pl issues
Message-ID: <20100924063616.GD18432@haskell.muteddisk.com>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
 <20100922232458.GB18432@haskell.muteddisk.com>
 <20100923022256.GB27057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923022256.GB27057@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:22 Wed 22 Sep     , Greg KH wrote:
> On Wed, Sep 22, 2010 at 04:24:58PM -0700, matt mooney wrote:
> > On 21:19 Mon 20 Sep     , Tracey Dent wrote:
> > > Fixed numerous coding style issues
> > > 
> > The subject should be more specific as to what the patch does, such as
> > "Staging: rtl8187se: r8180.h: whitespace cleanup."
> > 
> > And the explanation in the commit should also be more specific. There are
> > plenty of examples if you look through the log. Greg might except them as is,
> > but any future patches should follow the advice mentioned. Next time for a
> > patch of this nature remember to CC kernel-janitors too. 
> 
> Why the janitor list?  Do you really want that to be copied on every
> cleanup patch I get like this?  That would be a _lot_...

Heh, well hopefully not all the patches you receive. But there would have been
feedback sooner on this patch stating something along the lines of what I
said. The list is much lower volume making it is easier for devs doing cleanup,
like myself, to follow, so as to not duplicate our efforts. IMHO anyway.

While I have your attention, I am changing all makefiles to use the newer kbuild
flag variables, such as ccflags-y, asflags-y, and ldflags-y. I have already
completed this for all directories in the kernel except drivers which is
next. The patches are trivial but there are a lot in drivers, so should I break
it down by driver or is subdirectory okay? media/video has 85 instances in
something like 12 different subdirectories, so I am not sure what is
best. Please let me know what is best.

Thanks,
mfm
