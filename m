Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1KGO1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:27:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40028 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1KGO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:27:43 -0500
Date: Mon, 7 Nov 2011 14:27:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more
 generally
Message-ID: <20111107142740.GA17686@srcf.ucam.org>
References: <4EB39139.3090709@suse.de>
 <1320453843-938-1-git-send-email-trenn@suse.de>
 <20111107135923.GA17060@srcf.ucam.org>
 <201111071525.14255.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111071525.14255.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:25:13PM +0100, Thomas Renninger wrote:
> On Monday, November 07, 2011 02:59:24 PM Matthew Garrett wrote:
> > On Sat, Nov 05, 2011 at 01:44:03AM +0100, Thomas Renninger wrote:
> > > There are quite some reports that those do not reboot:
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/833705
> > > ->E6520, E6220
> > > http://www.linux-club.de/viewtopic.php?f=29&t=114459&start=20
> > > ->E5520
> > > and some more already are blacklisted
> > 
> > It's a bug in the SMM code on these machines, and it goes away if you 
> > disable VT-D. Let's try to actually fix it
> How do you intend to fix that?
> From description above it sounds as if this problem is not
> fixable from OS side.

Tear down VT-D state before reboot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
