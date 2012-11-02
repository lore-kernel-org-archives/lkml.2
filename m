Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199Ab2KBQdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:33:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab2KBQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:33:08 -0400
Date: Fri, 2 Nov 2012 17:33:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102163302.GA6080@elf.ucw.cz>
References: <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5092E361.7080901@genband.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2012-11-01 15:02:25, Chris Friesen wrote:
> On 11/01/2012 02:27 PM, Pavel Machek wrote:
> 
> >Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> >Because thats apparently what you want, and I don't think crippling kexec/suspend is
> >enough.
> 
> As I understand it, the kernel won't be signed by Microsoft.

> Rather, the bootloader will be signed by Microsoft and the vendors
> will be the ones that refuse to sign a kernel unless it is
> reasonably assured that it won't be used as an attack vector.

Yes. So can someone write down what "used as an attack vector" means?

Because, AFAICT, Linux kernel is _designed_ to work as an attact
vector. We intentionally support wine, and want to keep that support.

> With secure boot enabled, then the kernel should refuse to let an
> unsigned kexec load new images, and kexec itself should refuse to
> load unsigned images.  Also the kernel would need to sign its
> "suspend-to-disk" images and refuse to resume unsigned images.

I believe that attacking Windows using wine is easier than using
suspend-to-disk.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
