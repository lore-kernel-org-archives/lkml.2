Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992560Ab2KAVfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:35:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56862 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992489Ab2KAVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:35:01 -0400
Date: Thu, 1 Nov 2012 21:34:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101213452.GA20564@srcf.ucam.org>
References: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
 <1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
 <CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
 <1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
 <20121101210634.GA19723@srcf.ucam.org>
 <20121101213127.5967327f@pyramind.ukuu.org.uk>
 <20121101212843.GA20309@srcf.ucam.org>
 <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 09:37:51PM +0000, Alan Cox wrote:
> On Thu, 1 Nov 2012 21:28:43 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Lawyers won't remove blacklist entries.
> 
> Fear Uncertainty and Doubt
> 
> Courts do, injunctions do, the possibilty of getting caught with theirs
> hands in the till does.

I think you've misunderstood. Blacklist updates are append only.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
