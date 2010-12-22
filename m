Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0LVSni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:43:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:7737 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab0LVSnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:43:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,214,1291622400"; 
   d="scan'208";a="871005722"
Date: Wed, 22 Dec 2010 10:42:56 -0800
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Jochen Voss <voss@seehuhn.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc7
Message-ID: <20101222104256.3d501f94@jbarnes-desktop>
In-Reply-To: <20101222181855.GA4244@laptop>
References: <20101221233022.GA9188@seehuhn.de>
	<20101222181855.GA4244@laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010 20:18:55 +0200
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi,
> 
> On Tue, 21 Dec 2010 23:30:30 +0000, Jochen Voss wrote:
> > On Tue, Dec 21, 2010 at 11:52:17AM -0800, Linus Torvalds wrote:
> > > I'm still nervous about some of the regression reports for intel
> > > graphics, so please keep testing and reporting. This is the last -rc
> > > before xmas (or whatever your holiday may be), so now you all have a
> > > few free days when you have nothing better to do than test out an -rc
> > > release, right?
> >
> > For reference, the regression I reported yesterday
> > (message id "20101220140615.GA3035@automatix",
> > http://www.spinics.net/lists/kernel/msg1126718.html
> > on the web) is still present: -rc7 only shows a blank
> > screen on my system, -rc7 with 541cc966 reverted works
> > without problems.
> >
> 
> I can confirm the regression: a completely-blank screen right after the
> grub prompt.
> 
> Printing kernel output using early_printk() all along ('earlyprintk=
> serial,keep') shows that the rest of the kernel internally goes on with
> its booting process as usual.
> 
> Reverting the mentioned 541cc966 commit solves the problem; the bug is
> reproducible in both qemu and real hardware.

That one has since been reverted; I think Dave has it queued up for
Linus now actually.

-- 
Jesse Barnes, Intel Open Source Technology Center
