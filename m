Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0KONSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:18:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:36124 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0KONSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:18:02 -0500
Date: Mon, 15 Nov 2010 14:18:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>, stable@kernel.org
Subject: Re: [PATCH] input: bcm5974: Add support for MacBookAir3
In-Reply-To: <20101111083941.GE24415@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1011151417290.7420@pobox.suse.cz>
References: <1289320722-1948-1-git-send-email-rydberg@euromail.se> <20101111083941.GE24415@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Dmitry Torokhov wrote:

> On Tue, Nov 09, 2010 at 05:38:42PM +0100, Henrik Rydberg wrote:
> > From: Edgar (gimli) Hucek <gimli@dark-green.com>
> > 
> > This patch adds support for the MacBookAir3,1 and MacBookAir3,2
> > models.
> > 
> > [rydberg@euromail.se: touchpad range calibration]
> > Cc: stable@kernel.org
> > Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi Dmitry, Jiri,
> > 
> > This patch was seen on lkml last week, and has now been excercised by
> > a larger set of users. As usual, this patch should go before or
> > together with the HID changes, so as not to break basic support from
> > the non-MT HID driver.
> > 
> 
> Jiri,
> 
> It looks like HID changes are more than simply adding USB device IDs so
> it woudl make sense to merge through your tree,

Hi guys,

makes sense. I already have the HID bits in my tree, and will apply the 
bcm5974 part as well.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
