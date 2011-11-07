Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1KGPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:09:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab1KGPJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:09:56 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more generally
Date: Mon, 7 Nov 2011 16:09:54 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org
References: <4EB39139.3090709@suse.de> <201111071525.14255.trenn@suse.de> <20111107142740.GA17686@srcf.ucam.org>
In-Reply-To: <20111107142740.GA17686@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071609.54731.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 07, 2011 03:27:40 PM Matthew Garrett wrote:
> On Mon, Nov 07, 2011 at 03:25:13PM +0100, Thomas Renninger wrote:
> > On Monday, November 07, 2011 02:59:24 PM Matthew Garrett wrote:
> > > On Sat, Nov 05, 2011 at 01:44:03AM +0100, Thomas Renninger wrote:
> > > > There are quite some reports that those do not reboot:
> > > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/833705
> > > > ->E6520, E6220
> > > > http://www.linux-club.de/viewtopic.php?f=29&t=114459&start=20
> > > > ->E5520
> > > > and some more already are blacklisted
> > > 
> > > It's a bug in the SMM code on these machines, and it goes away if you 
> > > disable VT-D. Let's try to actually fix it
> > How do you intend to fix that?
> > From description above it sounds as if this problem is not
> > fixable from OS side.
> 
> Tear down VT-D state before reboot.
But doing this for all X86 machines because of a handful of
Dells with broken SMM code sounds wrong as well.

Doesn't Dell ship with Ubuntu pre-loaded?
Can't someone point them to this to get this fixed in BIOS?

   Thomas
