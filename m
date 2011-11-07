Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1KGOZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:25:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab1KGOZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:25:17 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more generally
Date: Mon, 7 Nov 2011 15:25:13 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org
References: <4EB39139.3090709@suse.de> <1320453843-938-1-git-send-email-trenn@suse.de> <20111107135923.GA17060@srcf.ucam.org>
In-Reply-To: <20111107135923.GA17060@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201111071525.14255.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 07, 2011 02:59:24 PM Matthew Garrett wrote:
> On Sat, Nov 05, 2011 at 01:44:03AM +0100, Thomas Renninger wrote:
> > There are quite some reports that those do not reboot:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/833705
> > ->E6520, E6220
> > http://www.linux-club.de/viewtopic.php?f=29&t=114459&start=20
> > ->E5520
> > and some more already are blacklisted
> 
> It's a bug in the SMM code on these machines, and it goes away if you 
> disable VT-D. Let's try to actually fix it
How do you intend to fix that?
>From description above it sounds as if this problem is not
fixable from OS side.

   Thomas

> rather than adding to the 
> blacklist, otherwise we'll just end up with another batch of broken 
> Dells later on.
