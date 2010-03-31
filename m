Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab0CaViY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:38:24 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1978 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab0CaViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:38:19 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Wed, 31 Mar 2010 14:23:09 -0700
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "Matthew Carlson" <mcarlson@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Mike Pagano" <mpagano@gentoo.org>, "Michael Chan" <mchan@broadcom.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [007/116] tg3: Fix 5906 transmit hangs
Message-ID: <20100331212309.GB16663@xw6200.broadcom.net>
References: <20100330230600.GA28802@kroah.com>
 <20100330225600.398306625@linux.site>
 <20100330211522.2f1658fe@redhat.com> <20100331203926.GA15418@suse.de>
MIME-Version: 1.0
In-Reply-To: <20100331203926.GA15418@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 67AD62B438O159187528-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:39:26PM -0700, Greg KH wrote:
> On Tue, Mar 30, 2010 at 09:15:22PM -0400, Chuck Ebbert wrote:
> > On Tue, 30 Mar 2010 15:54:45 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > 2.6.32-stable review patch.  If anyone has any objections, please let
> > > us know.
> > > 
> > > ------------------
> > > 
> > > From: Matt Carlson <mcarlson@broadcom.com>
> > > 
> > > This is a resubmit backport of commit
> > > 92c6b8d16a36df3f28b2537bed2a56491fb08f11 to kernel version 2.6.32.
> > > The gentoo bug report can be found at
> > > https://bugs.gentoo.org/show_bug.cgi?id=301091. Thanks to Matt
> > > Carlson for his assistance and working me to fix a regression caused
> > > by the initial patch.  The original description is as follows:
> > > 
> > 
> > I think these two patches should be used instead, as they fix the
> > bug without needing backports and keep the driver closer to upstream:
> > 
> > 0e1406dd404ce55dbe8d68b4b5e2aed7e5c75fdb
> > "tg3: Assign flags to fixes in start_xmit_dma_bug"
> > 
> > 92c6b8d16a36df3f28b2537bed2a56491fb08f11
> > "tg3: Fix 5906 transmit hangs"
> 
> I don't know, I'll defer to Matt here, this patch has gone in and out of
> the stable queue for a while now as he and some users have tested and
> had problems lots of times...
> 
> Matt?

I'm O.K. with either path.  I supported Mike's patch because it was
minimal.  (All the bugs should be shaken out by now.)  If that isn't a
goal, then I guess I'd rather rubber stamp my own implementation.

