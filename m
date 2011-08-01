Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1HAQo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:44:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55045 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1HAQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:44:21 -0400
Date: Mon, 1 Aug 2011 17:44:18 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fabien Marteau <fabien.marteau@armadeus.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] input: Add Nintendo extension controller driver
Message-ID: <20110801164418.GA5306@ponder.secretlab.ca>
References: <20110527081251.3992.27574.stgit@ponder>
 <CACxGe6vO=dtFmG4r5Da+T1EOknEofjEHqg_Jc_TCagju-no9mQ@mail.gmail.com>
 <20110801163823.GA3905@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801163823.GA3905@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 09:38:24AM -0700, Dmitry Torokhov wrote:
> Hi Grant,
> 
> On Mon, Aug 01, 2011 at 05:04:37PM +0100, Grant Likely wrote:
> > Hi Dmitry,
> > 
> > Any thoughts on this patch?  Can you send it on to Linus?
> > 
> 
> I thought I responded earlier but apparently not...
> 
> The issue with the driver is that it pre-registers an input device with
> a super-set of capabilities instead of waiting until the device is
> properly identified and registering input device with the exact
> capabilities.
> 
> The input policy is that device's stated capabilities should match the
> physical device (within the constraints of input framework).

Okay, that's solvable.  I'll rework and repost with a goal to merge in v3.2

g.

