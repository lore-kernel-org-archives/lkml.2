Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HUEuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 00:50:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:47758 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0HUEuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 00:50:13 -0400
Date: Fri, 20 Aug 2010 21:50:31 -0700
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Stanovich <mrktimber@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
Message-ID: <20100821045031.GA3291@suse.de>
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com> <4C6F4BBB.5040207@zytor.com> <AANLkTi=sKH95tLee+H03ah=8dF6LV9hpw+1esGSZuHRS@mail.gmail.com> <4C6F58DE.1010503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6F58DE.1010503@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 09:41:02PM -0700, H. Peter Anvin wrote:
> OK, I think we can consider this root-caused (it's unclear if it's our
> bug or gcc's, but adding "volatile" to the pointer solves the problem.)
> 
> Greg, do you want to take the listed upstream patches (thus bringing the
> code closer to mainline) or do you want to take the one-liner patch from
> the bugzilla?  [Attached for reference?]

Let me look at the 2 upstream patches tomorrow, and I'd prefer to take
them instead of something else, just to keep everything in sync.

thanks,

greg k-h
