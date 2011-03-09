Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1CIXGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:06:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:44773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CIXGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:06:38 -0500
Date: Thu, 10 Mar 2011 00:06:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH] HID: hid-magicmouse: Correct touch orientation
 direction
In-Reply-To: <4D77BC8C.8040801@canonical.com>
Message-ID: <alpine.LNX.2.00.1103100006270.19969@pobox.suse.cz>
References: <1299692337-1547-1-git-send-email-rydberg@euromail.se> <4D77BC8C.8040801@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011, Chase Douglas wrote:

> > The magic trackpad and mouse both report touch orientation in opposite
> > direction to the bcm5974 driver and what is written in
> > Documents/input/multi-touch-protocol.txt. This patch reverts the
> > direction, so that all in-kernel devices with this feature behave the
> > same way.
> > 
> > Since no known application has been utilizing this information yet, it
> > seems appropriate also for stable.
> > 
> > Cc: stable@kernel.org
> > Cc: Michael Poole <mdpoole@troilus.org>
> > Cc: Chase Douglas <chase.douglas@canonical.com>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Makes sense. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
