Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1CJX00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:26:26 -0500
Received: from smtp.nokia.com ([147.243.128.26]:59914 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab1CJX0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:26:25 -0500
Date: Fri, 11 Mar 2011 01:22:28 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
Message-ID: <20110310232228.GI7975@esdhcp04044.research.nokia.com>
References: <20110310212746.GA3361@suse.de> <1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com> <1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com> <20110310143806.7542e929.akpm@linux-foundation.org> <alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6> <20110310230621.GH7975@esdhcp04044.research.nokia.com> <alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/11 00:13 +0100, ext Thomas Gleixner wrote:
> On Fri, 11 Mar 2011, Phil Carmody wrote:
> > On 10/03/11 23:59 +0100, ext Thomas Gleixner wrote:
> > > On Thu, 10 Mar 2011, Andrew Morton wrote:
...
> > > > I don't think it's a terribly useful feature.  Except for when it _is_
> > > > useful, when it's very useful ;) The world wouldn't end if we decided
> > > > to remove it.
> > > 
> > > Amen to that.
> > > 
> > > It's more of an distraction than anything which is relevant to 99.999%
> > > of the problems we have to deal with.
> > 
> > As I indicated before, I've previously thought that too, but thought I
> > could 'fix' it by adding to it when I hit the once-in-three-years case.
> 
> The interesting question is:
> 
>  How did that info help and was it really the ultimate reason why you
>  found the underlying bug ?

It's academic now, as I fully support the removal. Perhaps the information
was most useful simply because it was given to me quickly, there would have
been other ways of divining it certainly (I can read hex stack dumps, for
example). Even I don't need this patch any more!

At least my intrusion has been useful for instigating a little cleanup!

Cheers,
Phil
