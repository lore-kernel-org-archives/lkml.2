Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2JLVQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:16:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2JLVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:16:07 -0400
Date: Sat, 13 Oct 2012 06:16:00 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Davidlohr Bueso <dave@gnu.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 011/120] lib/gcd.c: prevent possible div by 0
Message-ID: <20121012211600.GA24427@kroah.com>
References: <20121011005825.364610894@linuxfoundation.org>
 <20121011005827.374358602@linuxfoundation.org>
 <1350076284.4832.28.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350076284.4832.28.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:11:24PM +0100, Ben Hutchings wrote:
> On Thu, 2012-10-11 at 09:59 +0900, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > commit e96875677fb2b7cb739c5d7769824dff7260d31d upstream.
> > 
> > Account for all properties when a and/or b are 0:
> > gcd(0, 0) = 0
> > gcd(a, 0) = a
> > gcd(0, b) = b
> > 
> > Fixes no known problems in current kernels.
> [...]
> 
> I can't believe this change is harmful, but unless there are some known
> problems this doesn't meet the criteria for a stable update.

It was discussed in the original thread of this patch that it would be a
good idea to have this in the stable releases, and I agree.

greg k-h
