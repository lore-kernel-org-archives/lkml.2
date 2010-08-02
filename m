Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0HCAad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:30:33 -0400
Received: from kroah.org ([198.145.64.141]:60558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0HCAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:30:32 -0400
Date: Mon, 2 Aug 2010 16:59:50 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        glommer@redhat.com, alan@lxorguk.ukuu.org.uk, zamsden@redhat.com,
        stable@kernel.org, mtosatti@redhat.com, gregkh@suse.de,
        peter@palfrader.org, tglx@linutronix.de, avi@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
 to xchg() and cmpxchg()
Message-ID: <20100802235950.GA662@kroah.com>
References: <4C4F7277.8050306@zytor.com>
 <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
 <4C5759FF.1000807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5759FF.1000807@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 04:51:27PM -0700, Jeremy Fitzhardinge wrote:
>  On 07/27/2010 10:33 PM, tip-bot for H. Peter Anvin wrote:
> >Commit-ID:  113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> >Gitweb:     http://git.kernel.org/tip/113fc5a6e8c2288619ff7e8187a6f556b7e0d372
> >Author:     H. Peter Anvin<hpa@zytor.com>
> >AuthorDate: Tue, 27 Jul 2010 17:01:49 -0700
> >Committer:  H. Peter Anvin<hpa@zytor.com>
> >CommitDate: Tue, 27 Jul 2010 17:14:02 -0700
> >
> >x86: Add memory modify constraints to xchg() and cmpxchg()
> 
> Here's the 2.6.32 version for stable.

Thanks, I'll queue it up when it hits Linus's tree.

greg k-h
