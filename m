Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0GNQSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:18:18 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:37520 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0GNQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:18:16 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 12:18:16 EDT
Date: Wed, 14 Jul 2010 19:17:04 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, Sebastian Dalfu? <sd@sedf.de>,
        Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
Message-ID: <20100714161704.GE23436@shisha.kicks-ass.net>
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
 <20100714152337.GA13125@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714152337.GA13125@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 05:23:37 +0200, Sam Ravnborg wrote:
> On Wed, Jul 14, 2010 at 05:01:03PM +0300, Alexander Shishkin wrote:
> > The current implementation has been several times fixed to work around
> > different shells and build environments and it remains a somewhat tricky
> > shell script. This patch replaces all the dependencies by a single line
> > of perl. Build dependency on perl is not new, so that shouldn't be a
> > problem.
> > 
> > The new implementation does exactly what it's supposed to: it outputs
> > a little-endian 32-bit unsigned integer of a file's length.
> > 
> > This might simplify matters with different build environments and
> > different shells and is also considerably shorter and hopefully more
> > readable.
> 
> Reminds me that I had a patch that moved this to mkpiggy.c.
> Goggle gave this hit:
> 
>     http://lists.openwall.net/linux-kernel/2009/12/20/92

Ok, thanks for the reference.

> I will try to update this to cover arm also and check
> if other archs needs this.
> 
> In other word - move thes size stuff to mkpiggy so we
> skip this extra step.

Hm, maybe this mkpiggy can be made arch-independent and moved to scripts/
as well?

Regards,
--
Alex
