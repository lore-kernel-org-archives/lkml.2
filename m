Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab0IWTSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:18:33 -0400
Received: from kroah.org ([198.145.64.141]:51300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab0IWTSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:18:31 -0400
Date: Thu, 23 Sep 2010 11:37:24 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
 to xchg() and cmpxchg()
Message-ID: <20100923183724.GS23040@kroah.com>
References: <4C4F7277.8050306@zytor.com>
 <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
 <4C5759FF.1000807@goop.org>
 <20100802235950.GA662@kroah.com>
 <20100909195301.GA18291@nomi.cz>
 <4C894E64.3050800@zytor.com>
 <20100910131035.GA16636@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100910131035.GA16636@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:10:35PM +0200, Tomáš Janoušek wrote:
> Hello,
> 
> On Thu, Sep 09, 2010 at 02:15:16PM -0700, H. Peter Anvin wrote:
> > > The system boots and works just fine with 2.6.32.21 with the patch reverted.
> > > v2.6.36-rc3-185-gd56557a works fine as well, perhaps there were other fixes
> > > that didn't get to stable (e.g. 4532b30).
> > 
> > I believe this needs 69309a05907546fb686b251d4ab041c26afe1e1d, which I
> > think is being queued up for stable.
> > 
> > Could you try applying 69309a05907546fb686b251d4ab041c26afe1e1d and see
> > if it solves your problem.
> 
> It does indeed. Thanks.

Hm, that patch doesn't apply to the latest .32-stable tree.  Can someone
provide me with a backported version so I make sure I get it correct?

thanks,

greg k-h
