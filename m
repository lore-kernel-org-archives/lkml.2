Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1KGPMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:12:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38887 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1KGPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:12:16 -0500
Date: Mon, 7 Nov 2011 15:12:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more
 generally
Message-ID: <20111107151213.GA20270@srcf.ucam.org>
References: <4EB39139.3090709@suse.de>
 <201111071525.14255.trenn@suse.de>
 <20111107142740.GA17686@srcf.ucam.org>
 <201111071609.54731.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111071609.54731.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:09:54PM +0100, Thomas Renninger wrote:
> On Monday, November 07, 2011 03:27:40 PM Matthew Garrett wrote:
> > Tear down VT-D state before reboot.
> But doing this for all X86 machines because of a handful of
> Dells with broken SMM code sounds wrong as well.

We've already torn everything down at this point. What's the downside?

> Doesn't Dell ship with Ubuntu pre-loaded?
> Can't someone point them to this to get this fixed in BIOS?

I've been trying.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
