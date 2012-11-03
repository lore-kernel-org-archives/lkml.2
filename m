Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162Ab2KCAWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:22:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60119 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2KCAWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:22:52 -0400
Date: Sat, 3 Nov 2012 00:22:44 +0000
From: Matthew Garrett <mjg@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103002244.GC18691@srcf.ucam.org>
References: <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
 <20121102163302.GA6080@elf.ucw.cz>
 <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
 <20121102165456.GB9997@srcf.ucam.org>
 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
 <20121102175416.GA11816@srcf.ucam.org>
 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
 <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 11:38:23PM +0000, James Bottomley wrote:
> On Fri, 2012-11-02 at 18:04 +0000, Matthew Garrett wrote:
> > A user runs a binary that elevates itself to admin. Absent any flaws in 
> > Windows (cough), that should be all it can do in a Secure Boot world. 
> > But if you can drop a small trusted Linux system in there and use that 
> > to boot a compromised Windows kernel, it can make itself persistent.
> 
> We seem to be talking past each other.  Assume you managed to install a
> Linux boot system on the windows machine.  If the linux boot requires
> present user on first boot (either because the key of the bootloader
> isn't in db or because the MOK database isn't initialised), you still
> don't have a compromise because the loader won't start automatically.

Why would an attacker use one of those Linux systems? There's going to 
be plenty available that don't have that restriction.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
