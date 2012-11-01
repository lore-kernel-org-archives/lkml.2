Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063Ab2KAQ3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:29:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45880 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761813Ab2KAQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:29:11 -0400
Date: Thu, 1 Nov 2012 16:29:01 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101162901.GE13132@srcf.ucam.org>
References: <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <20121101144912.GA10269@srcf.ucam.org>
 <20121101150654.19efe0b5@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101150654.19efe0b5@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 03:06:54PM +0000, Alan Cox wrote:
> > The entire point of this feature is that it's no longer possible to turn 
> > a privileged user exploit into a full system exploit. Gaining admin 
> > access on Windows 8 doesn't permit you to install a persistent backdoor, 
> 
> Really, that would be a first. Do you have a detailed knowledge of
> windows 8 actual security ?

http://msdn.microsoft.com/en-us/library/windows/desktop/hh848061%28v=vs.85%29.aspx

> > unless there's some way to circumvent that. Which there is, if you can 
> > drop a small Linux distribution onto the ESP and use a signed, trusted 
> > bootloader to boot a signed, trusted kernel that then resumes from an 
> > unsigned, untrusted hibernate image. So we have to ensure that that's 
> > impossible.
> 
> Well if you want to make Linux entirely robust Red Hat could start
> helping with some of the 6000 odd coverity matches some of which will
> most certainly turn out to be real flaws.

Sure, bugs should be fixed.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
