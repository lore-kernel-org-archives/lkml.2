Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2JAVHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:07:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2JAVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:07:35 -0400
Date: Mon, 1 Oct 2012 23:07:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] First attempt at kernel secure boot support
Message-ID: <20121001210734.GB21712@elf.ucw.cz>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <20120904170853.0fa6b27b@pyramind.ukuu.org.uk>
 <20120904161256.GA22961@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904161256.GA22961@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-09-04 17:12:56, Matthew Garrett wrote:
> On Tue, Sep 04, 2012 at 05:08:53PM +0100, Alan Cox wrote:
> > On Tue,  4 Sep 2012 11:55:06 -0400
> > Matthew Garrett <mjg@redhat.com> wrote:
> > 
> > > The UEFI Secure Boot trust model is based on it not being possible for a
> > > user to cause a signed OS to boot an unsigned OS
> > 
> > Unfortunately you can't fix this at kernel level because an untrusted
> > application can at GUI level fake a system crash, reboot cycle and phish
> > any basic credentials such as passwords for the windows partition.
> 
> Any well-designed software asking for credentials should already be 
> requiring a SAK, so in that case we just need to implement sensible SAK 
> support in Linux.

So... the "secure" boot specification also describes what the SAK is?
It has to be same on all the operating systems to be effective.

And... you'd need to put SAK functionality into the kernel. (Currently
SAK only notifies _root_ user. You'd need to implement SAK
functionality displaying penguin with "This is not Windows"
message... in kernel).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
