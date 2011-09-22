Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1IVRZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:25:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58598 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1IVRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:25:46 -0400
Date: Thu, 22 Sep 2011 11:25:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Chris Ball <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm/tegra: Move EN_VDD_1V05_GPIO to board-harmony.h
Message-ID: <20110922172542.GK17168@ponder.secretlab.ca>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
 <CAOesGMisOtEQpcS-hHi-3brpYzJr-UiB6b71c+bwkesPDk9iuA@mail.gmail.com>
 <20110922081140.GH17169@n2100.arm.linux.org.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF1739554CBD@HQMAIL01.nvidia.com>
 <20110922163258.GD8072@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922163258.GD8072@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 05:32:58PM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 22, 2011 at 09:31:48AM -0700, Stephen Warren wrote:
> > Russell King - ARM Linux wrote at Thursday, September 22, 2011 2:12 AM:
> > > On Wed, Sep 21, 2011 at 01:16:49PM -0700, Olof Johansson wrote:
> > > > Works for me. Or I could stage it in a topic branch that would be
> > > > merged after Russell's GPIO tree.
> > > 
> > > Holding stuff off from being merged doesn't work.
> > 
> > Russell,
> > 
> > So I take it I should add the two ack'd patches to the ARM patch system,
> > and have you pick them up?
> 
> That's a workable solution, yes.  I've done that with various other
> gpio patches from people, and Grant seems happy with that.

Yes, I'm comfortable with patches going in via other trees when there
are dependencies.

g.
