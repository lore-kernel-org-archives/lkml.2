Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0LFN0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:26:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0LFN0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:26:38 -0500
Date: Mon, 6 Dec 2010 14:26:13 +0100
From: Karel Zak <kzak@redhat.com>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature
	to avoid user space breakage
Message-ID: <20101206132613.GB9421@nb.net.home>
References: <201012052324.30231.rjw@sisk.pl> <1291592215.2866.3.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291592215.2866.3.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 10:36:55AM +1100, Bojan Smojver wrote:
> On Sun, 2010-12-05 at 23:24 +0100, Rafael J. Wysocki wrote:
> > Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
> > modified hibernate signature used to mark swap partitions containing
> > hibernation images, but that turns out to have caused problems in
> > libblkid on recent Ubuntu.  Restore the old signature to avoid those
> > problems. 
> 
> Don't quite understand this change (sorry, probably just being obtuse).

 I too.

> The signature was changed to make sure older kernels don't handle
> compressed images by accident, right? If so, this would seem like a bad
> idea, because this is what can actually happen now.
> 
> Shouldn't user space learn how to handle both signatures instead?

 The upstream libblkid has been updated, there is not a problem to
 support more signatures.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
