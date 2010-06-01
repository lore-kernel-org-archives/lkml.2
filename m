Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0FAJ6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:58:07 -0400
Received: from 8bytes.org ([88.198.83.132]:53126 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0FAJ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:58:03 -0400
Date: Tue, 1 Jun 2010 11:58:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Nicolas Palix <npalix@diku.dk>,
       "x86@kernel.org" <x86@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Julia Lawall <julia@diku.dk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
Message-ID: <20100601095801.GB964@8bytes.org>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk> <20100527111136.GV3266@amd.com> <Pine.LNX.4.64.1005271317180.5422@ask.diku.dk> <201005271342.25619.npalix@diku.dk> <20100528071114.GA3266@amd.com> <4BFFF31C.9090904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFFF31C.9090904@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:45:16AM -0700, H. Peter Anvin wrote:
> On 05/28/2010 12:11 AM, Roedel, Joerg wrote:
> > On Thu, May 27, 2010 at 07:42:25AM -0400, Nicolas Palix wrote:
> >>> We have submitted and received some feedback on an initial version of 
> >>> this, but I'm not completely sure of the current status.
> >>
> >> You can see the latest feedback we get at
> >> http://lkml.org/lkml/2010/5/10/257
> >>
> >> The initial submission and its comments are at
> >> http://lkml.org/lkml/2010/4/26/269
> > 
> > I've also sent some feedback. Would be cool if you could work the
> > feedback in and do a repost asking Andrew to take it. Would be cool to
> > have this merged with 2.6.36.
> > 
> 
> I don't see why scripts that don't *in themselves* change the output
> binaries need to wait for .36.  Instead, it would be better to get them
> in sooner to make them available to developers in advance of the .36 cycle.
> 
> Of course, I'm not Linus, and I don't see him Cc:'d on this, but that
> would be the normal rules.

Yeah, merging it now would be even better. Since these scripts don't
change the kernel itself there is little risk to break anything. So how
about working in the feedback and sending an updated version to Linus
soon?

	Joerg

