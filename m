Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0HJWnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:43:31 -0400
Received: from kroah.org ([198.145.64.141]:54880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0HJWn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:43:27 -0400
Date: Tue, 10 Aug 2010 15:33:41 -0700
From: Greg KH <greg@kroah.com>
To: Peter Palfrader <peter@palfrader.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, tglx@linutronix.de,
        avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add memory modify constraints to xchg()
 and cmpxchg()
Message-ID: <20100810223340.GC18838@kroah.com>
References: <4C4F7277.8050306@zytor.com>
 <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
 <4C5759FF.1000807@goop.org>
 <20100803124351.GJ27199@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803124351.GJ27199@anguilla.noreply.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 02:43:51PM +0200, Peter Palfrader wrote:
> On Mon, 02 Aug 2010, Jeremy Fitzhardinge wrote:
> 
> >> Commit-ID:  113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> >> Gitweb:     http://git.kernel.org/tip/113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> >> Author:     H. Peter Anvin<hpa@zytor.com>
> >> AuthorDate: Tue, 27 Jul 2010 17:01:49 -0700
> >> Committer:  H. Peter Anvin<hpa@zytor.com>
> >> CommitDate: Tue, 27 Jul 2010 17:14:02 -0700
> >>
> >> x86: Add memory modify constraints to xchg() and cmpxchg()
> >
> > Here's the 2.6.32 version for stable.
> 
> Thanks a lot everyone.  This patch resolves the issue for me on top
> of 2.6.32.17.
> 
> (I had some whitespace issue with applying the patch, so I've attached
> the cleaned up version in case it wasn't just me.)

Thanks, I needed this version, it wasn't just you :)

greg k-h
