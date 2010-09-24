Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab0IXQD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:03:29 -0400
Received: from kroah.org ([198.145.64.141]:50920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0IXQDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:03:12 -0400
Date: Fri, 24 Sep 2010 08:52:00 -0700
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
Message-ID: <20100924155200.GA21235@kroah.com>
References: <4C4F7277.8050306@zytor.com>
 <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org>
 <4C5759FF.1000807@goop.org>
 <20100802235950.GA662@kroah.com>
 <20100909195301.GA18291@nomi.cz>
 <4C894E64.3050800@zytor.com>
 <20100910131035.GA16636@nomi.cz>
 <20100923183724.GS23040@kroah.com>
 <20100924071736.GA11988@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100924071736.GA11988@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:17:36AM +0200, Tomáš Janoušek wrote:
> Hello,
> 
> On Thu, Sep 23, 2010 at 11:37:24AM -0700, Greg KH wrote:
> > Hm, that patch doesn't apply to the latest .32-stable tree.  Can someone
> > provide me with a backported version so I make sure I get it correct?
> 
> I'm attaching the one I used and tested.

That worked, thanks, I've queued it up now.

greg k-h
