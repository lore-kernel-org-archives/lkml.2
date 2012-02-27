Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2B0PAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:00:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:56619 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2B0PAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:00:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121924422"
Date: Mon, 27 Feb 2012 16:07:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: twl-core: Add IRQ_DOMAIN dependency
Message-ID: <20120227150758.GT27687@sortiz-mobl>
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
 <1330102448-19172-2-git-send-email-grant.likely@secretlab.ca>
 <20120227101758.GI27687@sortiz-mobl>
 <CACxGe6t5+mSp2SwX1jr-H_NMrsqJrMSwXPRpen93ev=ryHC=2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6t5+mSp2SwX1jr-H_NMrsqJrMSwXPRpen93ev=ryHC=2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:54:52AM -0700, Grant Likely wrote:
> On Feb 27, 2012 3:10 AM, "Samuel Ortiz" <sameo@linux.intel.com> wrote:
> >
> > Hi Grant, Benoit,
> >
> > On Fri, Feb 24, 2012 at 09:54:08AM -0700, Grant Likely wrote:
> > > From: Benoit Cousson <b-cousson@ti.com>
> > >
> > > TWL4030 depends on IRQ_DOMAIN support, so this patch selects it in
> Kconfig.
> > > It used to be that CONFIG_IRQ_DOMAIN must only be selected by the
> architecture,
> > > but recent cleanups have fixed it so that it is safe to select from
> anywhere.
> > Applied to my for-next branch, thanks.
> 
> It has to go via my tree to get rid of the build failure properly.
Yes. I wasn't sure you pushed it already until I saw your reply to Andrew.
I removed it from my tree, thanks for taking care of that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
