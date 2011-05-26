Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1EZNRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:17:48 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:58796 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab1EZNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:47 -0400
Date: Thu, 26 May 2011 15:14:20 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <greg@kroah.com>, kevin.tian@intel.com, dkiper@net-space.pl,
        Rzeszutek@dumpdata.com, Wilk@dumpdata.com, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Message-ID: <20110526131420.GA20201@router-fw-old.local.net-space.pl>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com> <20110526070239.GB29833@kroah.com> <20110526123921.GB3386@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526123921.GB3386@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:39:21AM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, May 26, 2011 at 12:02:39AM -0700, Greg KH wrote:
> > On Wed, May 25, 2011 at 05:37:32PM -0400, Konrad@dumpdata.com wrote:
> > > Hey stable-tree maintainer(s).
> > >
> > > The follow four patches are in the 2.6.40 tree and should be back-ported to 2.6.39 (only).
> > > I forgot to CC:stable on them, so manually doing it here.
> > >
> > > The four patches in question have the following git commits:
> > >
> > > 8c5950881c3b5e6e350e4b0438a8ccc513d90df9
> > >     xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
> > > 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
> > >     xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit

Acked-by: Daniel Kiper <dkiper@net-space.pl>
(author of xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit patch)

Daniel
