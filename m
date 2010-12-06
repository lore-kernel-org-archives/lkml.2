Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0LFWXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:23:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0LFWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:23:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karel Zak <kzak@redhat.com>
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Mon, 6 Dec 2010 23:22:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
References: <201012052324.30231.rjw@sisk.pl> <1291592215.2866.3.camel@shrek.rexursive.com> <20101206132613.GB9421@nb.net.home>
In-Reply-To: <20101206132613.GB9421@nb.net.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012062322.45922.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010, Karel Zak wrote:
> On Mon, Dec 06, 2010 at 10:36:55AM +1100, Bojan Smojver wrote:
> > On Sun, 2010-12-05 at 23:24 +0100, Rafael J. Wysocki wrote:
> > > Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
> > > modified hibernate signature used to mark swap partitions containing
> > > hibernation images, but that turns out to have caused problems in
> > > libblkid on recent Ubuntu.  Restore the old signature to avoid those
> > > problems. 
> > 
> > Don't quite understand this change (sorry, probably just being obtuse).
> 
>  I too.
> 
> > The signature was changed to make sure older kernels don't handle
> > compressed images by accident, right? If so, this would seem like a bad
> > idea, because this is what can actually happen now.
> > 
> > Shouldn't user space learn how to handle both signatures instead?
> 
>  The upstream libblkid has been updated, there is not a problem to
>  support more signatures.

Cool.

I'm withdrawing the patch, then.

Thanks,
Rafael
